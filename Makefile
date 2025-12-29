.PHONY: help install lint stan test test-coverage

COMPOSER ?= $(shell command -v composer 2>/dev/null || echo ./composer.phar)
COVERAGE_DIR ?= build/coverage
PHPUNIT ?= ./vendor/bin/phpunit
PHPUNIT_FLAGS ?= --configuration phpunit.xml.dist

help:
	@echo "Available targets:"
	@echo "  make install                    Install PHP dependencies via Composer."
	@echo "  make lint                       Run parallel-lint on src/ directory."
	@echo "  make stan                       Run PHPStan static analysis."
	@echo "  make test                       Run all PHPUnit test suites."
	@echo "  make test-coverage              Run all tests with code coverage."

install:
	@if [ ! -f $(COMPOSER) ]; then \
		echo "Composer not found. Installing..."; \
		curl -sS https://getcomposer.org/installer | php; \
	fi
	$(COMPOSER) install

lint:
	./vendor/bin/parallel-lint --exclude .git --exclude vendor --exclude node_modules --exclude build --exclude tests src/

stan:
	./vendor/bin/phpstan analyze --configuration=phpstan.neon --memory-limit=1G

test:
	$(PHPUNIT) $(PHPUNIT_FLAGS)

$(COVERAGE_DIR):
	mkdir -p $(COVERAGE_DIR)

test-coverage: $(COVERAGE_DIR)
	XDEBUG_MODE=coverage $(PHPUNIT) $(PHPUNIT_FLAGS) --coverage-clover $(COVERAGE_DIR)/clover.xml --coverage-html $(COVERAGE_DIR)/html

