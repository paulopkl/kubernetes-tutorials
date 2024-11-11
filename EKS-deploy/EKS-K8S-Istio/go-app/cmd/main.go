package main

import (
	"log"
	"os"

	"github.com/gofiber/fiber/v2"
)

var (
	service string
	version string
)

func init() {
	version = os.Getenv("VERSION")
	service = os.Getenv("SERVICE")

	if service != "" {
		log.Fatalln("You MUST set SERVICE env variable!")
	}
}

func main() {
	app := fiber.New()
	app.Get("/api/devices", getDevices)
	app.Listen(":8080")
}
