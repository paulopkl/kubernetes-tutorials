package main

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/gofiber/fiber/v2"
)

type Device struct {
	ID       int    `json:"id"`
	Mac      string `json:"mac"`
	Firmware string `json:"firmware"`
}

type Response struct {
	Version string   `json:"version"`
	Devices []Device `json:"devices"`
}

func getDevices(c *fiber.Ctx) error {
	if service == "service-a" {
		url := "http://service-b.staging:8080/api/devices"

		var res Response

		r, err := http.Get(url)
		if err != nil {
			log.Fatalln(err)
		}
		defer r.Body.Close()

		err = json.NewDecoder(r.Body).Decode(&res)
		if err != nil {
			log.Fatalln(err)
		}

		return c.JSON(res)
	} else {
		dvs := []Device{
			{
				ID:       1,
				Mac:      "5F-33-CC-1F-43-82",
				Firmware: "2.1.6",
			},
		}

		res := Response{
			Devices: dvs,
			Version: version,
		}

		return c.JSON(res)
	}
}
