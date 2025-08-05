import config from 'config';
import Redis, { RedisOptions } from 'ioredis';

const redisConfig: RedisOptions = config.get('redis');
export const client = new Redis({
  host: process.env.REDIS_HOST  || redisConfig.host || 'localhost',
  port: process.env.REDIS_PORT ? parseInt(process.env.REDIS_PORT, 10) : (redisConfig.port || 6379),
  keyPrefix: redisConfig.keyPrefix || 'craig:',
  lazyConnect: true
});

console.log("=== BOT ===\n", "REDIS HOST: ", process.env.REDIS_HOST, "\nREDIS PORT: ", process.env.REDIS_PORT)

interface Cooldown {
  uses: number;
  expires: number;
}

interface Maintenance {
  message: string;
}

export async function processCooldown(key: string, duration: number, uses: number) {
  const currentTime = Date.now();
  const cooldownString = await client.get(`cooldown:${key}`);
  const cooldown: Cooldown = cooldownString ? JSON.parse(cooldownString) : { uses, expires: currentTime + duration * 1000 };
  cooldown.uses--;
  if (cooldown.uses <= 0 && currentTime < cooldown.expires) return cooldown;
  const expiry = (cooldown.expires - currentTime) / 1000;
  if (Math.round(expiry) > 0) await client.set(`cooldown:${key}`, JSON.stringify(cooldown), 'EX', Math.round(expiry));
  return true;
}

export async function checkMaintenance(clientId: string): Promise<Maintenance | false> {
  const maintenanceString = await client.get(`maintenance:${clientId}`);
  if (!maintenanceString) return false;
  return JSON.parse(maintenanceString);
}

export async function setMaintenance(clientId: string, data: Maintenance): Promise<void> {
  await client.set(`maintenance:${clientId}`, JSON.stringify(data));
}

export async function removeMaintenance(clientId: string): Promise<void> {
  await client.del(`maintenance:${clientId}`);
}
