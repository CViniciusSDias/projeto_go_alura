package database

import (
	"log"
	"os"

	"github.com/guilhermeonrails/api-go-gin/models"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var (
	DB  *gorm.DB
	err error
)

func ConectaComBancoDeDados() {
	endereco := os.Getenv("DB_HOST")
	usuario := os.Getenv("DB_USER")
	senha := os.Getenv("DB_PASSWORD")
	nomeBanco := os.Getenv("DB_NAME")
	portaBanco := os.Getenv("DB_PORT")

	stringDeConexao := "host=" + endereco + " user=" + usuario + " password=" + senha + " dbname=" + nomeBanco + " port=" + portaBanco + " sslmode=disable"

	DB, err = gorm.Open(postgres.Open(stringDeConexao), &gorm.Config{})
	if err != nil {
		log.Printf("⚠️ Erro ao se conectar com o banco de dados: %v", err)
		// Retorna sem matar a aplicação
		// log.Panic("Erro ao se conectar com o banco de dados")

		return
	}

	log.Println("✅ Conectado ao banco com sucesso!")

	// Migrate apenas se conectou com sucesso
	err = DB.AutoMigrate(&models.Aluno{})
	if err != nil {
		log.Printf("⚠️ Falha ao realizar o AutoMigrate: %v", err)
	}
}
