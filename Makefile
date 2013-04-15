REBAR = rebar

all:
	@ $(REBAR) get-deps compile

clean:
	@ $(REBAR) delete-deps
	@ rm -rf deps
	@ rm -rf ebin
	@ rm -rf doc
