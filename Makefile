# 使用POSIX标准的bash作为SHELL，提高跨平台兼容性
SHELL := /bin/bash
# 定义常量
COLOR_RESET ?= \033[0m
COLOR_GREEN ?= \033[32;01m
# 定义变量
PYTHON_VERSION := $(shell python --version | awk '{print $$2}')
PIP_VERSION    := $(shell pip --version | awk '{print $$2}')
NODE_VERSION   := $(shell node --version | sed 's/^v//')
NPM_VERSION    := $(shell npm --version)
YARN_VERSION   := $(shell yarn --version)
# 构建项目
build: version
	sphinx-build -M html "source" "build"
# 部署项目
deploy: build
	netlify deploy --prod
# 启动开发服务器
dev: build
	python -m http.server --directory ./build/html/ 8080
# 安装环境
env:
	asdf install
# 格式化代码
fmt:
	yarn run format
# 自动修复代码格式
fix:
	yarn run format:fix
# 确保依赖是最新的
install: version
	pip install --requirement requirements.txt
	yarn install --frozen-lockfile
# 查看提交历史记录
log:
	git log --oneline --decorate --graph --all
# 推送代码
push:
	git push
# 打印版本信息
version:
	@echo -e "$(COLOR_GREEN)"
	@echo "=============================="
	@echo "  Python:  v  $(PYTHON_VERSION) $(shell which python)"
	@echo "  pip:     v  $(PIP_VERSION) $(shell which pip)"
	@echo "  Node.js: v $(NODE_VERSION) $(shell which node)"
	@echo "  NPM:     v  $(NPM_VERSION) $(shell which npm)"
	@echo "  Yarn:    v $(YARN_VERSION) $(shell which yarn)"
	@echo "=============================="
	@echo -e "$(COLOR_RESET)"
