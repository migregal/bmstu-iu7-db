package structs

import (
	"fmt"
	"github.com/bxcodec/faker/v3"
)

type Shops struct {
	Id         string  `faker:"uuid_hyphenated,unique"`
	Company    string  `faker:"uuid_hyphenated,unique"`
	Name       string  `faker:"word"`
	Latitude   float32 `faker:"lat,unique"`
	Longitude  float32 `faker:"long,unique"`
	Registered string  `faker:"date"`
}

func (s Shops) ToSlice() []string {
	return []string{s.Id, s.Company, s.Name, fmt.Sprintf("%f", s.Latitude), fmt.Sprintf("%f", s.Longitude), s.Registered}
}

func GetShopsHeaders() []string {
	return []string{"id", "company", "name", "latitude", "longitude", "registered"}
}

func GetRandomShop() Shops {
	t := Shops{}

	err := faker.FakeData(&t)
	if err != nil {
		panic(err)
	}

	return t
}
