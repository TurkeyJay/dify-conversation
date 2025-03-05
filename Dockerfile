FROM --platform=linux/amd64 node:20.10.0-bullseye-slim

WORKDIR /app

COPY . .
USER root
# 设置 npm 和 pnpm 的镜像源并安装 pnpm
RUN npm config set registry https://registry.npmmirror.com && \
    npm install -g pnpm && \
    pnpm config set registry https://registry.npmmirror.com

# 清理已存在的 node_modules 目录，然后设置目录权限
RUN rm -rf /app/node_modules && \
    chown -R node:node /app

# 切换到 node 用户
USER node

# 使用 pnpm 安装依赖和构建
RUN pnpm install --frozen-lockfile --prefer-offline
RUN pnpm build

EXPOSE 3000

CMD ["pnpm", "start"]
