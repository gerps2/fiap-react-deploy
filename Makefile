# Makefile para FIAP React Deploy
# Compatível com macOS e Linux

# Detectar sistema operacional
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	OS = macOS
else
	OS = Linux
endif

# Variáveis
APP_NAME = fiap-react-deploy
DOCKER_IMAGE = $(APP_NAME)
NODE_VERSION = 22
PORT = 8080
DEV_PORT = 8081

# Cores para output
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

.PHONY: help install dev build test lint docker-build docker-run docker-dev clean setup health deploy-dev deploy-prod release

# Target padrão
all: help

## 📋 Ajuda
help:
	@echo "$(GREEN)🚀 FIAP React Deploy - Makefile Commands$(NC)"
	@echo ""
	@echo "$(YELLOW)📦 Desenvolvimento:$(NC)"
	@echo "  make install     - Instalar dependências"
	@echo "  make dev         - Executar em modo desenvolvimento"
	@echo "  make build       - Build da aplicação"
	@echo "  make test        - Executar testes"
	@echo "  make lint        - Executar ESLint"
	@echo ""
	@echo "$(YELLOW)🐳 Docker:$(NC)"
	@echo "  make docker-build    - Build da imagem Docker"
	@echo "  make docker-run      - Executar container (produção)"
	@echo "  make docker-dev      - Executar container (desenvolvimento)"
	@echo "  make docker-compose  - Executar com docker-compose"
	@echo ""
	@echo "$(YELLOW)🌿 GitFlow:$(NC)"
	@echo "  make git-setup       - Configurar Git e GitFlow"
	@echo "  make feature-start   - Iniciar nova feature (FEATURE=nome)"
	@echo "  make feature-finish  - Finalizar feature (FEATURE=nome)"
	@echo "  make release-start   - Iniciar release (VERSION=x.x.x)"
	@echo "  make release-finish  - Finalizar release (VERSION=x.x.x)"
	@echo "  make hotfix-start    - Iniciar hotfix (VERSION=x.x.x)"
	@echo "  make hotfix-finish   - Finalizar hotfix (VERSION=x.x.x)"
	@echo ""
	@echo "$(YELLOW)🚀 Deploy:$(NC)"
	@echo "  make deploy-dev      - Deploy para desenvolvimento"
	@echo "  make deploy-prod     - Deploy para produção (cria tag)"
	@echo "  make create-tag      - Criar tag de versão (VERSION=x.x.x)"
	@echo ""
	@echo "$(YELLOW)🔧 Utilitários:$(NC)"
	@echo "  make health      - Verificar saúde da aplicação"
	@echo "  make clean       - Limpar arquivos temporários"
	@echo "  make setup       - Configuração inicial completa"
	@echo ""
	@echo "$(GREEN)Sistema detectado: $(OS)$(NC)"

## 📦 Instalar dependências
install:
	@echo "$(GREEN)📦 Instalando dependências...$(NC)"
	npm ci --force
	@echo "$(GREEN)✅ Dependências instaladas!$(NC)"

## 🚀 Executar em desenvolvimento
dev:
	@echo "$(GREEN)🚀 Iniciando servidor de desenvolvimento...$(NC)"
	npm run dev

## 🔨 Build da aplicação
build:
	@echo "$(GREEN)🔨 Buildando aplicação...$(NC)"
	npm run build
	@echo "$(GREEN)✅ Build concluído!$(NC)"

## 🧪 Executar testes
test:
	@echo "$(GREEN)🧪 Executando testes...$(NC)"
	npm run test:coverage
	@echo "$(GREEN)✅ Todos os testes passaram!$(NC)"

## 🔍 Executar ESLint
lint:
	@echo "$(GREEN)🔍 Executando ESLint...$(NC)"
	npm run lint
	@echo "$(GREEN)✅ Código está conforme!$(NC)"

## 🐳 Build da imagem Docker
docker-build:
	@echo "$(GREEN)🐳 Buildando imagem Docker...$(NC)"
	docker build \
		--build-arg VITE_ENVIRONMENT=production \
		--build-arg VITE_APP_VERSION=latest \
		--build-arg VITE_BUILD_TIMESTAMP=$$(date -u +"%Y-%m-%dT%H:%M:%S.000Z") \
		-t $(DOCKER_IMAGE):latest \
		.
	@echo "$(GREEN)✅ Imagem Docker criada!$(NC)"

## 🚀 Executar container (produção)
docker-run: docker-build
	@echo "$(GREEN)🚀 Executando container em produção...$(NC)"
	docker run -d --name $(APP_NAME) -p $(PORT):8080 \
		-e NODE_ENV=production \
		-e ENVIRONMENT=production \
		$(DOCKER_IMAGE):latest
	@echo "$(GREEN)✅ Container executando na porta $(PORT)!$(NC)"
	@make health

## 🧪 Executar container (desenvolvimento)
docker-dev:
	@echo "$(GREEN)🧪 Executando container em desenvolvimento...$(NC)"
	docker build \
		--build-arg VITE_ENVIRONMENT=dev \
		--build-arg VITE_APP_VERSION=dev-latest \
		--build-arg VITE_BUILD_TIMESTAMP=$$(date -u +"%Y-%m-%dT%H:%M:%S.000Z") \
		--build-arg VITE_DEBUG=true \
		-t $(DOCKER_IMAGE):dev \
		.
	docker run -d --name $(APP_NAME)-dev -p $(DEV_PORT):8080 \
		-e NODE_ENV=development \
		-e ENVIRONMENT=dev \
		-e DEBUG=true \
		$(DOCKER_IMAGE):dev
	@echo "$(GREEN)✅ Container dev executando na porta $(DEV_PORT)!$(NC)"

## 🐳 Executar com docker-compose
docker-compose:
	@echo "$(GREEN)🐳 Executando com docker-compose...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)✅ Aplicação executando via docker-compose!$(NC)"

## 🌿 Configurar Git e GitFlow
git-setup:
	@echo "$(GREEN)🌿 Configurando Git e GitFlow...$(NC)"
	git config --global init.defaultBranch main
	git config --global pull.rebase false
	@if command -v git-flow >/dev/null 2>&1; then \
		echo "$(GREEN)✅ Git Flow já está instalado!$(NC)"; \
	else \
		echo "$(YELLOW)⚠️  Instalando Git Flow...$(NC)"; \
		if [ "$(OS)" = "macOS" ]; then \
			brew install git-flow-avh; \
		else \
			sudo apt-get install git-flow || sudo yum install gitflow; \
		fi; \
	fi
	@echo "$(GREEN)✅ Git configurado!$(NC)"

## 🌟 Iniciar nova feature
feature-start:
	@if [ -z "$(FEATURE)" ]; then \
		echo "$(RED)❌ Use: make feature-start FEATURE=nome-da-feature$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)🌟 Iniciando feature: $(FEATURE)$(NC)"
	git checkout develop
	git pull origin develop
	git checkout -b feature/$(FEATURE)
	@echo "$(GREEN)✅ Feature $(FEATURE) criada! Branch: feature/$(FEATURE)$(NC)"

## ✅ Finalizar feature
feature-finish:
	@if [ -z "$(FEATURE)" ]; then \
		echo "$(RED)❌ Use: make feature-finish FEATURE=nome-da-feature$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)✅ Finalizando feature: $(FEATURE)$(NC)"
	git checkout feature/$(FEATURE)
	git add .
	git commit -m "✨ feat: complete feature $(FEATURE)" || true
	git checkout develop
	git pull origin develop
	git merge feature/$(FEATURE)
	git push origin develop
	git branch -d feature/$(FEATURE)
	@echo "$(GREEN)✅ Feature $(FEATURE) finalizada e merged em develop!$(NC)"

## 🚀 Iniciar release
release-start:
	@if [ -z "$(VERSION)" ]; then \
		echo "$(RED)❌ Use: make release-start VERSION=1.0.0$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)🚀 Iniciando release: $(VERSION)$(NC)"
	git checkout develop
	git pull origin develop
	git checkout -b release/$(VERSION)
	@echo "$(GREEN)✅ Release $(VERSION) criada! Branch: release/$(VERSION)$(NC)"

## 🎉 Finalizar release
release-finish:
	@if [ -z "$(VERSION)" ]; then \
		echo "$(RED)❌ Use: make release-finish VERSION=1.0.0$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)🎉 Finalizando release: $(VERSION)$(NC)"
	git checkout release/$(VERSION)
	git add .
	git commit -m "🔖 release: version $(VERSION)" || true
	git checkout main
	git pull origin main
	git merge release/$(VERSION)
	git tag -a v$(VERSION) -m "🎉 Release version $(VERSION)"
	git push origin main
	git push origin v$(VERSION)
	git checkout develop
	git merge release/$(VERSION)
	git push origin develop
	git branch -d release/$(VERSION)
	@echo "$(GREEN)🎉 Release $(VERSION) finalizada e tag criada!$(NC)"

## 🔥 Iniciar hotfix
hotfix-start:
	@if [ -z "$(VERSION)" ]; then \
		echo "$(RED)❌ Use: make hotfix-start VERSION=1.0.1$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)🔥 Iniciando hotfix: $(VERSION)$(NC)"
	git checkout main
	git pull origin main
	git checkout -b hotfix/$(VERSION)
	@echo "$(GREEN)✅ Hotfix $(VERSION) criado! Branch: hotfix/$(VERSION)$(NC)"

## 🚑 Finalizar hotfix
hotfix-finish:
	@if [ -z "$(VERSION)" ]; then \
		echo "$(RED)❌ Use: make hotfix-finish VERSION=1.0.1$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)🚑 Finalizando hotfix: $(VERSION)$(NC)"
	git checkout hotfix/$(VERSION)
	git add .
	git commit -m "🔥 hotfix: version $(VERSION)" || true
	git checkout main
	git pull origin main
	git merge hotfix/$(VERSION)
	git tag -a v$(VERSION) -m "🚑 Hotfix version $(VERSION)"
	git push origin main
	git push origin v$(VERSION)
	git checkout develop
	git merge hotfix/$(VERSION)
	git push origin develop
	git branch -d hotfix/$(VERSION)
	@echo "$(GREEN)🚑 Hotfix $(VERSION) finalizado e tag criada!$(NC)"

## 🏷️ Criar tag de versão
create-tag:
	@if [ -z "$(VERSION)" ]; then \
		echo "$(RED)❌ Use: make create-tag VERSION=1.0.0$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)🏷️ Criando tag: v$(VERSION)$(NC)"
	git checkout main
	git pull origin main
	git tag -a v$(VERSION) -m "🎉 Release version $(VERSION)"
	git push origin v$(VERSION)
	@echo "$(GREEN)✅ Tag v$(VERSION) criada e enviada!$(NC)"
	@echo "$(YELLOW)🚀 Deploy em produção será iniciado automaticamente...$(NC)"

## 🚀 Deploy para desenvolvimento
deploy-dev:
	@echo "$(GREEN)🚀 Fazendo deploy para desenvolvimento...$(NC)"
	git checkout develop
	git pull origin develop
	git push origin develop
	@echo "$(GREEN)✅ Deploy para desenvolvimento iniciado!$(NC)"
	@echo "$(YELLOW)📋 Acompanhe o progresso em: https://github.com/gerps2/fiap-react-deploy/actions$(NC)"

## 🌟 Deploy para produção
deploy-prod:
	@if [ -z "$(VERSION)" ]; then \
		echo "$(RED)❌ Use: make deploy-prod VERSION=1.0.0$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)🌟 Fazendo deploy para produção: $(VERSION)$(NC)"
	@make create-tag VERSION=$(VERSION)
	@echo "$(GREEN)✅ Deploy para produção iniciado!$(NC)"
	@echo "$(YELLOW)📋 Acompanhe o progresso em: https://github.com/gerps2/fiap-react-deploy/actions$(NC)"

## 🏥 Verificar saúde da aplicação
health:
	@echo "$(GREEN)🏥 Verificando saúde da aplicação...$(NC)"
	@sleep 3
	@if curl -f http://localhost:$(PORT)/health 2>/dev/null; then \
		echo "$(GREEN)✅ Aplicação está saudável!$(NC)"; \
	else \
		echo "$(YELLOW)⚠️  Aplicação não está respondendo na porta $(PORT)$(NC)"; \
	fi

## 🧹 Limpar arquivos temporários
clean:
	@echo "$(GREEN)🧹 Limpando arquivos temporários...$(NC)"
	rm -rf node_modules/.cache
	rm -rf dist
	rm -rf coverage
	docker system prune -f 2>/dev/null || true
	docker container stop $(APP_NAME) 2>/dev/null || true
	docker container rm $(APP_NAME) 2>/dev/null || true
	docker container stop $(APP_NAME)-dev 2>/dev/null || true
	docker container rm $(APP_NAME)-dev 2>/dev/null || true
	@echo "$(GREEN)✅ Limpeza concluída!$(NC)"

## ⚙️ Configuração inicial completa
setup: git-setup install
	@echo "$(GREEN)⚙️ Executando configuração inicial...$(NC)"
	@make test
	@make docker-build
	@echo "$(GREEN)🎉 Configuração inicial concluída!$(NC)"
	@echo ""
	@echo "$(YELLOW)📋 Próximos passos:$(NC)"
	@echo "  1. Configure os secrets no GitHub (COOLIFY_WEBHOOK_DEV, COOLIFY_WEBHOOK_PROD, etc.)"
	@echo "  2. Use 'make feature-start FEATURE=nome' para iniciar desenvolvimento"
	@echo "  3. Use 'make deploy-dev' para deploy em desenvolvimento"
	@echo "  4. Use 'make deploy-prod VERSION=1.0.0' para deploy em produção" 