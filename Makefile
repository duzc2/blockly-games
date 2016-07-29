##############################
# Definitions
##############################

USER_APPS = index puzzle maze bird turtle movie pond/docs pond/tutor pond/duck
ALL_JSON = ./ index puzzle maze bird turtle movie pond/docs pond pond/tutor pond/duck
ALL_TEMPLATES = appengine/template.soy,appengine/index/template.soy,appengine/puzzle/template.soy,appengine/maze/template.soy,appengine/bird/template.soy,appengine/turtle/template.soy,appengine/movie/template.soy,appengine/pond/docs/template.soy,appengine/pond/template.soy,appengine/pond/tutor/template.soy,appengine/pond/duck/template.soy

APP_ENGINE_THIRD_PARTY = appengine/third-party
SOY_COMPILER = java -jar third-party/SoyToJsSrcCompiler.jar --shouldProvideRequireSoyNamespaces --isUsingIjData
SOY_EXTRACTOR = java -jar third-party/SoyMsgExtractor.jar

BLOCKY_DIR = $(PWD)

##############################
# Rules
##############################

all: deps languages

index-en:
	mkdir -p appengine/generated/en/
	$(SOY_COMPILER) --outputPathFormat appengine/index/generated/en/soy.js --srcs appengine/index/template.soy
	python build-app.py index en

puzzle-en: common-en
	$(SOY_COMPILER) --outputPathFormat appengine/puzzle/generated/en/soy.js --srcs appengine/puzzle/template.soy
	python build-app.py puzzle en

maze-en: common-en
	$(SOY_COMPILER) --outputPathFormat appengine/maze/generated/en/soy.js --srcs appengine/maze/template.soy
	python build-app.py maze en

bird-en: common-en
	$(SOY_COMPILER) --outputPathFormat appengine/bird/generated/en/soy.js --srcs appengine/bird/template.soy
	python build-app.py bird en

turtle-en: common-en
	$(SOY_COMPILER) --outputPathFormat appengine/turtle/generated/en/soy.js --srcs appengine/turtle/template.soy
	python build-app.py turtle en

movie-en: common-en
	$(SOY_COMPILER) --outputPathFormat appengine/movie/generated/en/soy.js --srcs appengine/movie/template.soy
	python build-app.py movie en

pond-docs-en:
	mkdir -p appengine/pond/generated/en/
	$(SOY_COMPILER) --outputPathFormat appengine/pond/docs/generated/en/soy.js --srcs appengine/pond/docs/template.soy
	python build-app.py pond/docs en

pond-tutor-en: pond-common-en
	$(SOY_COMPILER) --outputPathFormat appengine/pond/tutor/generated/en/soy.js --srcs appengine/pond/tutor/template.soy
	python build-app.py pond/tutor en

pond-duck-en: pond-common-en
	$(SOY_COMPILER) --outputPathFormat appengine/pond/duck/generated/en/soy.js --srcs appengine/pond/duck/template.soy
	python build-app.py pond/duck en

pond-common-en: common-en
	$(SOY_COMPILER) --outputPathFormat appengine/pond/generated/en/soy.js --srcs appengine/pond/template.soy
common-en:
	$(SOY_COMPILER) --outputPathFormat appengine/generated/en/soy.js --srcs appengine/template.soy

en: index-en puzzle-en maze-en bird-en turtle-en movie-en pond-docs-en pond-tutor-en pond-duck-en

index-zh-hans:
	mkdir -p appengine/generated/zh-hans/
	$(SOY_COMPILER) --outputPathFormat appengine/index/generated/zh-hans/soy.js --srcs appengine/index/template.soy
	python build-app.py index zh-hans

puzzle-zh-hans: common-zh-hans
	$(SOY_COMPILER) --outputPathFormat appengine/puzzle/generated/zh-hans/soy.js --srcs appengine/puzzle/template.soy
	python build-app.py puzzle zh-hans

maze-zh-hans: common-zh-hans
	$(SOY_COMPILER) --outputPathFormat appengine/maze/generated/zh-hans/soy.js --srcs appengine/maze/template.soy
	python build-app.py maze zh-hans

bird-zh-hans: common-zh-hans
	$(SOY_COMPILER) --outputPathFormat appengine/bird/generated/zh-hans/soy.js --srcs appengine/bird/template.soy
	python build-app.py bird zh-hans

turtle-zh-hans: common-zh-hans
	$(SOY_COMPILER) --outputPathFormat appengine/turtle/generated/zh-hans/soy.js --srcs appengine/turtle/template.soy
	python build-app.py turtle zh-hans

movie-zh-hans: common-zh-hans
	$(SOY_COMPILER) --outputPathFormat appengine/movie/generated/zh-hans/soy.js --srcs appengine/movie/template.soy
	python build-app.py movie zh-hans

pond-docs-zh-hans:
	mkdir -p appengine/pond/generated/zh-hans/
	$(SOY_COMPILER) --outputPathFormat appengine/pond/docs/generated/zh-hans/soy.js --srcs appengine/pond/docs/template.soy
	python build-app.py pond/docs zh-hans

pond-tutor-zh-hans: pond-common-zh-hans
	$(SOY_COMPILER) --outputPathFormat appengine/pond/tutor/generated/zh-hans/soy.js --srcs appengine/pond/tutor/template.soy
	python build-app.py pond/tutor zh-hans

pond-duck-zh-hans: pond-common-zh-hans
	$(SOY_COMPILER) --outputPathFormat appengine/pond/duck/generated/zh-hans/soy.js --srcs appengine/pond/duck/template.soy
	python build-app.py pond/duck zh-hans

pond-common-zh-hans: common-zh-hans
	$(SOY_COMPILER) --outputPathFormat appengine/pond/generated/zh-hans/soy.js --srcs appengine/pond/template.soy
common-zh-hans:
	$(SOY_COMPILER) --outputPathFormat appengine/generated/zh-hans/soy.js --srcs appengine/template.soy

zh-hans: index-zh-hans puzzle-zh-hans maze-zh-hans bird-zh-hans turtle-zh-hans movie-zh-hans pond-docs-zh-hans pond-tutor-zh-hans pond-duck-zh-hans


languages:
	$(SOY_EXTRACTOR) --outputFile extracted_msgs.xlf --srcs $(ALL_TEMPLATES)
	i18n/xliff_to_json.py --xlf extracted_msgs.xlf --templates $(ALL_TEMPLATES)
	@for app in $(ALL_JSON); do \
	  mkdir -p appengine/$$app/generated; \
	  i18n/json_to_js.py --path_to_jar third-party --output_dir appengine/$$app/generated --template appengine/$$app/template.soy --key_file json/keys.json json/*.json; \
	done
	@for app in $(USER_APPS); do \
	  echo; \
	  echo --- $$app; \
	  for lang in `ls appengine/$$app/generated`; do \
	    python build-app.py $$app $$lang; \
	  done \
	done

deps:
	mkdir -p third-party
	@# All following commands are in third-party, use backslashes to keep them on the same line as the cd command.
	cd third-party; \
	svn checkout https://github.com/google/closure-library/trunk/closure/bin/build build; \
	wget -N https://dl.google.com/closure-templates/closure-templates-for-javascript-latest.zip; \
	unzip -o closure-templates-for-javascript-latest.zip SoyToJsSrcCompiler.jar; \
	unzip -o closure-templates-for-javascript-latest.zip -d ../$(APP_ENGINE_THIRD_PARTY) soyutils_usegoog.js; \
	wget -N https://dl.google.com/closure-templates/closure-templates-msg-extractor-latest.zip; \
	unzip -o closure-templates-msg-extractor-latest.zip SoyMsgExtractor.jar; \
	wget -N https://dl.google.com/closure-compiler/compiler-latest.zip; \
	unzip -o compiler-latest.zip -x COPYING README.md; \
	mv -f closure-compiler-v*.jar closure-compiler.jar; \
	chmod +x build/closurebuilder.py

	mkdir -p $(APP_ENGINE_THIRD_PARTY)
	svn checkout https://github.com/google/closure-library/trunk/closure/goog/ $(APP_ENGINE_THIRD_PARTY)/goog
	svn checkout https://github.com/google/closure-library/trunk/third_party/closure/goog/ $(APP_ENGINE_THIRD_PARTY)/third_party_goog
	svn checkout https://github.com/ajaxorg/ace-builds/trunk/src-min-noconflict/ $(APP_ENGINE_THIRD_PARTY)/ace
	svn checkout https://github.com/google/blockly/trunk/ $(APP_ENGINE_THIRD_PARTY)/blockly
	svn checkout https://github.com/mudcube/MIDI.js/trunk/@365 $(APP_ENGINE_THIRD_PARTY)/midi-js
	@# messages.js confuses the compiler by also providing "Blockly.Msg.en".
	rm $(APP_ENGINE_THIRD_PARTY)/blockly/msg/messages.js
	svn checkout https://github.com/NeilFraser/JS-Interpreter/trunk/ $(APP_ENGINE_THIRD_PARTY)/JS-Interpreter
	java -jar third-party/closure-compiler.jar\
	 --js appengine/third-party/JS-Interpreter/acorn.js\
	 --js appengine/third-party/JS-Interpreter/interpreter.js\
	 --js_output_file appengine/third-party/JS-Interpreter/compiled.js

clean: clean-languages clean-deps

clean-languages:
	@for app in $(ALL_JSON); do \
	  rm -rf appengine/$$app/generated; \
	  echo $$app removed; \
	done
	rm -f json/keys.json

clean-deps:
	rm -rf appengine/third-party
	rm -rf third-party

# Prevent non-traditional rules from exiting with no changes.
.PHONY: deps
