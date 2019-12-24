init:
	git init
	touch .git/info/exclude

	#	maven-wrapper
	mvn -N io.takari:maven:wrapper -Dmaven=3.6.3
	rm mvnw.cmd
	chmod +x ./mvnw
	echo "/.mvn\n/mvnw*\n" >> .git/info/exclude

	#	checkstyler
	curl -O https://raw.githubusercontent.com/checkstyle/checkstyle/master/src/main/resources/google_checks.xml
	echo "/google_checks.xml\n" >> .git/info/exclude

uninit:
	rm -rf .mvn mvnw* google_checks.xml .git/info/exclude

reboot: clear uninit init

uninit-full: clear uninit
	rm -rf .idea *.iml .git

reboot-full: uninit-full init
	echo "/.java-version\n/.idea/\n/aeroport-igor.iml\n/out/\n/classes/\n" >> .git/info/exclude
	git add src .editorconfig .gitignore Makefile pom.xml README.md
	idea pom.xml

jshell:
	jshell --enable-preview --start PRINTING --start JAVASE --class-path `mvn dependency:build-classpath | grep -A1 'Dependencies classpath' | tail -1`

build:
	./mvnw verify
	chmod +x ./target/aeroport-igor-0.0.1-SNAPSHOT.jar

run:
	./mvnw spring-boot:run -Dspring.profiles.active=local
	#	./target/aeroport-igor-0.0.1-SNAPSHOT.jar
	#	java -jar --enable-preview ./target/aeroport-igor-0.0.1-SNAPSHOT.jar

archetype: clear uninit
	./mvnw archetype:create-from-project -Darchetype.properties=archetype.properties
	#	cd target/generated-sources/archetype/.idea && rm workspace.xml usage.statistics.xml tasks.xml
	make init
	#	idea ./target/generated-sources/archetype/pom.xml
	cd target/generated-sources/archetype && ./../../../mvnw clean install

clone: archetype
	cd .. && mvn archetype:generate \
		-DarchetypeGroupId=ru.vlapin.projects \
		-DarchetypeArtifactId=monolith-archetype \
		-DartifactId=monolith-example \
		-DarchetypeVersion=0.0.1-SNAPSHOT \
		-DgroupId=ru.vlapin.projects \
		-Dpackage=ru.vlapin.projects.monolith \
		-Dversion=0.0.1-SNAPSHOT \
		-DinteractiveMode=false

	idea ./../monolith-example/pom.xml

clear:
	./mvnw clean

test: clear
	./mvnw test

update:
	./mvnw versions:update-parent versions:update-properties versions:display-plugin-updates

delombok: clear
	mkdir -p ./target/generated-sources/delombok ./target/generated-test-sources/delombok
	ln -s ./java ./src/main/lombok
	ln -s ./java ./src/test/lombok
	#	./mvnw lombok:delombok lombok:testDelombok
	java -cp `mvn dependency:build-classpath | grep -A1 'Dependencies classpath' | tail -1` -jar ~/.m2/repository/org/projectlombok/lombok/$lombokVer$/lombok-$lombokVer$.jar delombok ./src/main/lombok -d ./target/generated-sources/delomboked
	java -cp `mvn dependency:build-classpath | grep -A1 'Dependencies classpath' | tail -1` -jar ~/.m2/repository/org/projectlombok/lombok/$lombokVer$/lombok-$lombokVer$.jar delombok ./src/test/lombok -d ./target/generated-sources/test-delomboked
	rm ./src/main/lombok ./src/test/lombok

# see: https://stackoverflow.com/questions/7244321/how-do-i-update-a-github-forked-repository
git-fork-init: init
#	Add the remote, call it "upstream":
	git remote add upstream git://github.com/Vyacheslav-Lapin/aeroport-igor.git

#	Fetch all the branches of that remote into remote-tracking branches,
#	such as upstream/master:
	git fetch upstream

#	Make sure that you're on your master branch:
	git checkout master

#	Rewrite your master branch so that any commits of yours that
#	aren't already in upstream/master are replayed on top of that
#	other branch:
	git rebase upstream/master

#branch name
B=feature
git-branch:
	git checkout -b $(B)
	git push -u origin $(B)

.DEFAULT_GOAL := default-action
default-action:
	./mvnw
