MKLIB=ocamlmklib
OCAMLOPT=ocamlopt
OCAMLC=ocamlc

# Set this to -p for profiler support
PROFILE=

PROGS=echo worker

.SUFFIXES: .ml .mli .cmi .cmx

all: $(PROGS)

echo: echo.ml
	$(OCAMLOPT) $(PROFILE) -o $@ -I ../src \
		unix.cmxa gearman.cmxa echo.ml

worker: worker.ml
	$(OCAMLOPT) $(PROFILE) -o $@ -I ../src \
		unix.cmxa gearman.cmxa worker.ml

clean:
	rm -f *.a *.cma *.cmxa *.cmx *.mli *.cmi *.cmo *.o
	rm -f $(PROGS)

.ml.mli:
	$(OCAMLOPT) -o .buildtmp -i $< > $@
	rm .buildtmp

.ml.cmi:
	$(MKLIB) $<
