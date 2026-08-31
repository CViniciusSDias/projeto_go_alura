lint:
	#CURDIR (no makefile) = PWD
	sudo docker run --rm -itv $(CURDIR):/app -w /app golangci/golangci-lint golangci-lint run controllers/ database/ models/ routes/
test:
	sudo docker run --rm \
	--network projeto_go_alura_default \
	-v $(CURDIR):/app \
	-w /app \
	-e DB_HOST=postgres \
	-e DB_USER=root \
	-e DB_PASSWORD=root \
	-e DB_NAME=root \
	-e DB_PORT=5432 \
	golang:1.22 go test ./... -v
start:
	sudo docker-compose up -d
ci: start lint test
cd:
	sudo docker run --rm -itv $(CURDIR):/app -w /app golang:1.22-alpine go build main.go
	scp -ri "~/.ssh/curso-cd-aws.pem" $(CURDIR)/templates ec2-user@ec2-54-160-106-151.compute-1.amazonaws.com:/home/ec2-user
	scp -ri "~/.ssh/curso-cd-aws.pem" $(CURDIR)/assets ec2-user@ec2-54-160-106-151.compute-1.amazonaws.com:/home/ec2-user
	scp -i "~/.ssh/curso-cd-aws.pem" $(CURDIR)/main ec2-user@ec2-54-160-106-151.compute-1.amazonaws.com:/home/ec2-user
	# Servidor de Prod
	# ENV ./main
