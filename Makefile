VERSION=$(shell head -n 1 VERSION)

all: pms
clean:
	rm -fr zentaopms
	rm -fr zentaostory
	rm -fr zentaotask
	rm -fr zentaotest
	rm -fr *.tar.gz
	rm -fr *.zip
	rm -fr api*
	rm -fr build/linux/lampp
	rm -fr lampp
pms:
	mkdir zentaopms
	cp -fr bin zentaopms/
	cp -fr config zentaopms/ && rm -fr zentaopms/config/my.php
	cp -fr db zentaopms/
	cp -fr doc zentaopms/ && rm -fr zentaopms/doc/phpdoc && rm -fr zentaopms/doc/doxygen
	cp -fr framework zentaopms/
	cp -fr lib zentaopms/
	cp -fr module zentaopms/
	cp -fr www zentaopms && rm -fr zentaopms/www/data/ && mkdir -p zentaopms/www/data/upload
	cp -fr tmp zentaopms
	rm -fr zentaopms/tmp/cache/* 
	rm -fr zentaopms/tmp/extension/*
	rm -fr zentaopms/tmp/log/*
	rm -fr zentaopms/tmp/model/*
	cp VERSION zentaopms/
	# combine js and css files.
	cp -fr tools zentaopms/tools && cd zentaopms/tools/ && php ./minifyfront.php
	rm -fr zentaopms/tools
	# create the restart file for svn.
	# touch zentaopms/module/svn/restart
	# delee the unused files.
	find zentaopms -name .gitkeep |xargs rm -fr
	find zentaopms -name tests |xargs rm -fr
	# notify.zip.
	mkdir zentaopms/www/data/notify/
	# change mode.
	chmod 777 -R zentaopms/tmp/
	chmod 777 -R zentaopms/www/data
	chmod 777 -R zentaopms/config
	chmod 777 zentaopms/module
	chmod a+rx zentaopms/bin/*
	find zentaopms/ -name ext |xargs chmod -R 777
	echo full > zentaopms/.flow
	zip -r -9 ZenTaoPMS.$(VERSION).zip zentaopms
	rm -fr zentaopms
patchphpdoc:
	sudo cp misc/doc/phpdoc/*.tpl /usr/share/php/data/PhpDocumentor/phpDocumentor/Converters/HTML/frames/templates/phphtmllib/templates/
phpdoc:
	phpdoc -d bin,framework,config,lib,module,www -t api -o HTML:frames:phphtmllib -ti ZenTaoPMSAPI�ο��ֲ� -s on -pp on -i *test*
	phpdoc -d bin,framework,config,lib,module,www -t api.chm -o chm:default:default -ti ZenTaoPMSAPI�ο��ֲ� -s on -pp on -i *test*
doxygen:
	doxygen doc/doxygen/doxygen.conf
