
redis: 
	cd redis; docker build -t dockerexample/redis .

redis_clean:
	cd redis; docker build --no-cache=true -t dockerexample/redis .

mysql:
	cd mysql; docker build -t dockerexample/mysql .

mysql_clean:
	cd mysql; docker build --no-cache=true -t dockerexample/mysql .

sinatra:
	cd sinatra; docker build -t dockerexample/sinatra .

sinatra_clean:
	cd sinatra; docker build --no-cache=true -t dockerexample/sinatra .

all: redis mysql
	@echo Done. Check output for any possible errors
	@echo type \"docker images\" to list the built images

.PHONY: redis redis_clean mysql mysql_clean sinatra sinatra_clean all
