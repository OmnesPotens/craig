module.exports = {
    apps: [
      {
        name: 'Craig',
        cwd: '/app/apps/bot',
        script: 'dist/sharding/index.js',
        wait_ready: true,
        kill_timeout: 3000,
        env: {
          NODE_ENV: 'development'
        },
        env_production: {
          NODE_ENV: 'production'
        }
      },
      {
        name: 'Craig Dashboard',
        cwd: '/app/apps/dashboard',
        script: 'npm',
        args: 'start',
        env: {
          NODE_ENV: 'development'
        },
        env_production: {
          NODE_ENV: 'production'
        }
      },
      {
        name: 'craig.horse',
        cwd: '/app/apps/download',
        script: 'dist/index.js',
        instances: '8',
        exec_mode: 'cluster',
        wait_ready: true,
        listen_timeout: 10000,
        kill_timeout: 3000,
        env: {
          NODE_ENV: 'development'
        },
        env_production: {
          NODE_ENV: 'production'
        }
      },
      {
        name: 'Craig Tasks',
        cwd: '/app/apps/tasks',
        script: 'dist/index.js',
        wait_ready: true,
        kill_timeout: 3000,
        env: {
          NODE_ENV: 'development'
        },
        env_production: {
          NODE_ENV: 'production'
        }
      }
    ]
  };