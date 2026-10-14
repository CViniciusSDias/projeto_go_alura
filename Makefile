lint:
	docker run --rm -it -v "$(CURDIR):/app" -w /app golangci/golangci-lint golangci-lint run controllers/ database/ models/ routes/
test:
	docker run --rm -v "$(CURDIR):/app" -w /app --network projeto_go_alura_default -e DB_HOST=postgres -e DB_USER=root -e DB_PASSWORD=root -e DB_NAME=root -e DB_PORT=5432 golang:1.22-alpine go test -v main_test.go
start:
	docker compose up -d
ci: start lint test
cd:
	docker run --rm -itv $(CURDIR):/app -w /app golang:1.22-alpine go build main.go
	scp -ri "~/.ssh/curso-cd-aws.pem" $(CURDIR)/templates ec2-user@ec2-54-160-106-151.compute-1.amazonaws.com:/home/ec2-user
	scp -ri "~/.ssh/curso-cd-aws.pem" $(CURDIR)/assets ec2-user@ec2-54-160-106-151.compute-1.amazonaws.com:/home/ec2-user
	scp -i "~/.ssh/curso-cd-aws.pem" $(CURDIR)/main ec2-user@ec2-54-160-106-151.compute-1.amazonaws.com:/home/ec2-user
	# Servidor de Prod
	# ENV ./main