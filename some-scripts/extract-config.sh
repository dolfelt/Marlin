#!/bin/sh

(diff -u config/default/Configuration.h Marlin/Configuration.h ; \
 diff -u config/default/Configuration_adv.h Marlin/Configuration_adv.h) | \
	sed -e 's@^\([+-]/*\)[\t ]*@\1@' -e 's@  *//.*@@g' | \
	awk '
		function getVal(n) {
			rv=""
			for(i = n; i <= NF; i++) rv=rv FS $i;
			gsub("\"", "\\\"", rv);
			gsub("&", "\\\\&", rv);
			sub("^[[:blank:]]*", "", rv);
			return rv
		}

		BEGIN { on=off=""; split("", keys); }

		/^-\/*#define[[:blank:]]+[[:alnum:]_]+/ { oldCfg[$2]=getVal(3); if(/^-\/+/) wasOff[$2]=1 }
		/^+\/*#define[[:blank:]]+[[:alnum:]_]+/ { newCfg[$2]=getVal(3); if(/^+\/+/) isOff[$2]=1; keys[length(keys)]=$2 }

		END {
 			print "restore_configs";
			for(i in keys) {
				k=keys[i];
				v=newCfg[k];
				if(v == "" && !(k in isOff)) {
					on=on " " k;
					continue;
				}
				if(!(k in isOff) || v != oldCfg[k]) {
					if(k in oldCfg) {
						print "opt_set" " " k " \"" v "\""
					} else {
						print "opt_add" " " k " \"" v "\""
					}
				}
				if(k in isOff) {
					off=off " " k;
				}
			}
			for(k in oldCfg)
				if(!(k in newCfg) && !(k in wasOff)) off=off " " k;
			if(on) print "opt_enable" on;
			if(off) print "opt_disable" off;
		}'
