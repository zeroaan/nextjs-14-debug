FROM node:20-alpine AS base
 
FROM base AS deps

# Set working directory
WORKDIR /app

# bound mount ? 
# host , ec2 directory 동기화

# COPY . .
# COPY package.json pnpm-lock.yaml* pnpm-workspace.yaml* packages/constant/package.json packages/i18n/package.json packages/stores/package.json packages/ui/package.json packages/utils/package.json apps/xclusive-ssr/package.json ./

COPY . .
# alpine 기반 이미지의 경우, 공통적으로 dlopen 라이브러리를 사용하는데, 간혹 실행 환경에 있어서, 해당 라이브러리가 없는 경우가 있음. 아래 코드는 해당 라이브러리를 추가하는 코드.
# RUN apk add --no-cache libc6-compat
# # 만약 위 코드 실행 시, 필수, 외엔 제거해도 괜찮음
# RUN apk update

# # pnpm 
RUN corepack enable
RUN pnpm i
RUN pnpm build


FROM base AS runner
WORKDIR /app

RUN apk add --no-cache libc6-compat
RUN apk update
RUN corepack enable

COPY --from=deps /app/next.config.mjs .
COPY --from=deps /app/package.json .
COPY --from=deps /app/.next/standalone .
COPY --from=deps /app/.next/static ./.next/static
COPY --from=deps /app/public ./public

EXPOSE 3000

ENV HOSTNAME="0.0.0.0"
ENV PORT="3000"

RUN sed -i'' -e 's/process.env.HOSTNAME/"0.0.0.0"/g' server.js
CMD ["node", "server.js"]

# # # Add lockfile and package.json's of isolated subworkspace
# FROM base AS installer

# WORKDIR /app
# # # First install the dependencies (as they change less often)
# COPY --from=deps /app .
# COPY /out/full .

# RUN apk add --no-cache libc6-compat
# RUN apk update
# RUN corepack enable

# # RUN pnpm i --frozen-lockfile
# # RUN pnpm exec next telemetry disable
# RUN pnpm build:ssr

# FROM base AS runner
# WORKDIR /app

# RUN apk add --no-cache libc6-compat
# RUN apk update
# RUN corepack enable

# COPY --from=installer /app/apps/xclusive-ssr/next.config.js .
# COPY --from=installer /app/apps/xclusive-ssr/package.json .
# COPY --from=installer /app/apps/xclusive-ssr/.next/standalone ./
# COPY --from=installer /app/apps/xclusive-ssr/.next/static ./apps/xclusive-ssr/.next/static
# COPY --from=installer /app/apps/xclusive-ssr/public ./apps/xclusive-ssr/public

# EXPOSE 3000

# ENV HOSTNAME="0.0.0.0"
# ENV PORT="3000"

# RUN sed -i'' -e 's/process.env.HOSTNAME/"0.0.0.0"/g' apps/xclusive-ssr/server.js
# CMD ["node", "apps/xclusive-ssr/server.js"]
