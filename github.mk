.PHONY: all add commit push

all: add commit push

add:
	git add .

commit:
	git commit -m '$(comment)'

push:
	git push origin

