NAME = ft_turing
DUNE = dune

all: install_deps
	@$(DUNE) build bin/main.exe
	@cp _build/default/bin/main.exe $(NAME)
	@echo "Сборка завершена! Исполняемый файл: ./$(NAME)"

install_deps:
	@echo "Проверка зависимостей..."
	@if ! command -v opam > /dev/null; then \
		echo "Ошибка: OPAM не установлен. Пожалуйста, установите OPAM."; \
		exit 1; \
	fi
	@if ! opam list --installed dune > /dev/null || ! opam list --installed yojson > /dev/null; then \
		echo "Установка недостающих зависимостей через OPAM..."; \
		opam update; \
		opam install -y dune yojson; \
	else \
		echo "Все зависимости установлены."; \
	fi

clean:
	@$(DUNE) clean
	@echo "Очистка временных файлов сборки."

fclean: clean
	@rm -f $(NAME)
	@echo "Исполняемый файл удален."

re: fclean all

.PHONY: all install_deps clean fclean re
