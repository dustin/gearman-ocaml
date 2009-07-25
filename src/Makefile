MKLIB=ocamlmklib
OCAMLMKTOP=ocamlmktop
OCAMLOPT=ocamlopt
OCAMLC=ocamlc

PARTS=gearman.cmx

.SUFFIXES: .ml .mli .cmi .cmx

.PHONY: $(PARTS)

all: libgearman

libgearman: $(PARTS)
	$(MKLIB) -o gearman \
		gearman.cmo \
		gearman.cmx
	rm -f libgearman.a
	ln gearman.a libgearman.a

clean:
	rm $(PARTS) *.cmxa *.cma *.cmi *.cmx *.a *.o *.cmo a.*

docs: $(PARTS)
	mkdir -p doc
	ocamldoc -t "Gearman Client Docs" -keep-code -colorize-code -d doc -html \
		*.mli *.ml

.mli.cmi: $<
	$(MKLIB) $< `echo $< | sed s/.mli/.ml/`

gearman.cmo: gearman.cmi
gearman.cmx: gearman.cmi
