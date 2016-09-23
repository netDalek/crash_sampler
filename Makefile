REBAR := $(shell which ./rebar || which rebar)

all: compile
	$(REBAR) compile

compile:
	$(REBAR) compile

rel: compile
	$(REBAR) release

run: all
	$(REBAR) shell

test:
	$(REBAR) eunit skip_deps=true verbose=3

clean:
	$(REBAR) clean
