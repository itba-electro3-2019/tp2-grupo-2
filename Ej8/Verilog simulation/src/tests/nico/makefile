# This makefile is inspired from: https://stackoverflow.com/questions/7004702/how-can-i-create-a-makefile-for-c-projects-with-src-obj-and-bin-subdirectories

# project name (generate executable with this name)
TARGET   = test

GTKWAVE = gtkwave
VCD_OUTPUT = output.vcd

EXECUTOR = vvp
COMPILER = iverilog
CFLAGS   = 

# change these to proper directories where each file should be
SRCDIR   = src
BINDIR   = bin

SOURCES  := $(wildcard $(SRCDIR)/*.v)
OBJECTS  := $(SOURCES:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
rm       = rm -f

$(BINDIR)/$(TARGET): $(SOURCES)
	@mkdir -p bin
	@$(COMPILER) $(SOURCES) $(CFLAGS) -o $@
	@echo "Compilation complete!"

.PHONY: run
run: $(BINDIR)/$(TARGET)
	@echo "Running simulation!"
	@$(EXECUTOR) $(BINDIR)/$(TARGET) +VCD_PATH=$(BINDIR)/$(VCD_OUTPUT)

.PHONY: view
view: run
	@echo "Viewing simulation!"
	@$(GTKWAVE) $(BINDIR)/$(VCD_OUTPUT) >/dev/null 2>&1 &

.PHONY: clean
clean: 
	@$(rm) $(BINDIR)/$(TARGET)
	@echo "Executable removed!"

.PHONY: clean
purge: clean
	@$(rm) -rf $(BINDIR)
	@echo "Purge complete!"

