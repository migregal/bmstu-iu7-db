package models

import (
	"log"

	"github.com/gobuffalo/envy"
	"github.com/gobuffalo/pop/v5"
)

var DB *pop.Connection

func init() {
	var err error
	env := envy.Get("GO_ENV", "development")
	DB, err = pop.Connect(env)
	if err != nil {
		log.Fatal(err)
	}
	pop.Debug = env == "development"
}
