
# # 使用 Amazon Corretto 17 镜像作为基础镜像
# FROM amazoncorretto:17-alpine

# # 设置工作目录
# WORKDIR /app

# # 将项目的 JAR 文件复制到容器中的 /app 目录
# COPY ./RS_web-1.0-SNAPSHOT.jar /app/RS_web-1.0-SNAPSHOT.jar


# # 设置容器的默认命令来启动 JAR 文件
# ENTRYPOINT ["java", "-jar", "/app/RS_web-1.0-SNAPSHOT.jar"]

# # 暴露应用运行的端口 (根据你项目实际使用的端口调整)
# EXPOSE 8084

# # 如果需要设置环境变量，使用 ENV 命令 (例如，设置 JAVA_OPTS 等)
# # ENV JAVA_OPTS="-Xmx512m"










# 使用 Node.js 作为基础镜像，适用于构建和启动 Vue 3 项目
FROM node:20

# 设置工作目录
WORKDIR /app/newxunbao


# 复制项目文件到容器
COPY newxunbao /app/newxunbao

# 安装依赖
RUN npm cache clean --force && npm install && npm install -g vite


# 暴露开发服务器的端口
EXPOSE 8888

# 启动开发服务器
CMD ["npm", "run", "dev"]






# # 使用 Python 官方镜像作为基础镜像 

# FROM python:3.9-slim 

# # 设置工作目录 

# WORKDIR /app 

# # 只将 test_for_imp 目录复制到容器中 

# COPY get_goods_info  /app/get_goods_info 

# # 安装 requirements.txt 中的依赖 

# RUN pip install --no-cache-dir -r /app/get_goods_info/requirements.txt 

# # 设置环境变量，确保 Flask 在开发模式下运行 

# WORKDIR /app/get_goods_info 

# ENV FLASK_ENV=development 

# # 暴露 Flask 默认端口

# EXPOSE 8083 

# # 启动 Flask 应用 

# CMD ["python", "app.py"] 