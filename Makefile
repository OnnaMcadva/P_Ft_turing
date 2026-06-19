# Colors
DEF_COLOR   = \033[0;39m
GRAY        = \033[0;90m
RED         = \033[0;91m
GREEN       = \033[0;92m
YELLOW      = \033[0;93m
BLUE        = \033[0;94m
MAGENTA     = \033[0;95m
CYAN        = \033[0;96m
WHITE       = \033[0;97m
ORANGE      = \033[38;5;222m
GREEN_BR    = \033[38;5;118m
YELLOW_BR   = \033[38;5;227m
PINK_BR     = \033[38;5;206m
BLUE_BR     = \033[38;5;051m

# Text styles
BOLD        = \033[1m
UNDERLINE   = \033[4m
BLINK       = \033[5m

# Project
NAME        = ft_turing
DUNE        = dune

all: install_deps $(NAME)

$(NAME):
	@echo "$(BOLD)$(CYAN)Compiling $(NAME)...$(DEF_COLOR)"
	@echo ""
	@echo "$(BOLD)$(BLUE_BR)<><><><><><><><><><><><><><><><><><><><><><><><><><>$(DEF_COLOR)"
	@echo ""
	@$(DUNE) build bin/main.exe
	@cp _build/default/bin/main.exe $(NAME)
	@echo "$(BOLD)$(GREEN_BR)      _________________________________________________ $(DEF_COLOR)"
	@echo "$(BOLD)$(GREEN_BR)     /                                                 \ \$(DEF_COLOR)"
	@echo "$(BOLD)$(GREEN_BR)    |   ___________________________________________     |$(DEF_COLOR)"
	@echo "$(BOLD)$(GREEN_BR)    |  |                                           |    |$(DEF_COLOR)"
	@echo "$(BOLD)$(GREEN_BR)    |  |     $(BLUE_BR)[1] [0] [1] <1> [0] [1] [.] [.]$(GREEN_BR)       |    |$(DEF_COLOR)"
	@echo "$(BOLD)$(GREEN_BR)    |  |___________________________________________|    |$(DEF_COLOR)"
	@echo "$(BOLD)$(GREEN_BR)    |                                                   |$(DEF_COLOR)"
	@echo "$(BOLD)$(GREEN_BR)    |   $(YELLOW_BR)      ft_turing is ready to simulate!$(GREEN_BR)           |       $(DEF_COLOR)"
	@echo "$(BOLD)$(GREEN_BR)    |___________________________________________________|$(DEF_COLOR)"
	@echo "$(BOLD)$(GREEN_BR)           \\___________________________________/$(DEF_COLOR)"
	@echo "$(BOLD)$(GREEN_BR)                \\_________________________/$(DEF_COLOR)"
	@echo ""
	@echo "$(BOLD)$(GREEN)Compilation successful! You can now run './$(NAME)' to start the Turing machine simulator.$(DEF_COLOR)"
	@echo ""

install_deps:
	@echo ""
	@echo "$(BOLD)$(BLUE_BR)<><><><><><><><><><><><><><><><><><><><><><><>$(DEF_COLOR)"
	@echo ""
	@echo "$(BOLD)$(YELLOW)Checking dependencies...$(DEF_COLOR)"
	@if ! command -v opam > /dev/null; then \
		echo "$(BOLD)$(RED)Error: OPAM is not installed. Please install OPAM first.$(DEF_COLOR)"; \
		exit 1; \
	fi
	@if ! opam list --installed dune > /dev/null || ! opam list --installed yojson > /dev/null; then \
		echo "$(BOLD)$(ORANGE)Installing missing dependencies via OPAM...$(DEF_COLOR)"; \
		opam update; \
		opam install -y dune yojson; \
	else \
		echo "$(BOLD)$(GREEN)All dependencies are satisfied.$(DEF_COLOR)"; \
	fi

clean:
	@echo "$(BOLD)$(RED)Cleaning build files...$(DEF_COLOR)"
	@$(DUNE) clean

fclean: clean
	@echo "$(BOLD)$(RED)Removing executable...$(DEF_COLOR)"
	@rm -f $(NAME)

re: fclean all

.PHONY: all install_deps clean fclean re
