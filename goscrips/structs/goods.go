package structs

import (
	"github.com/bxcodec/faker/v3"
)

type Goods struct {
	Id                  string `faker:"uuid_hyphenated,unique"`
	Name                string `faker:"word"`
	Description         string `faker:"paragraph,unique"`
	Year                string `faker:"year"`
	Manufacturer        string `faker:"word"`
	ManufacturerWebsite string `faker:"domain_name"`
}

func (s Goods) ToSlice() []string {
	return []string{s.Id, s.Name, s.Description, s.Year, s.Manufacturer, s.ManufacturerWebsite}
}

func GetGoodsHeaders() []string {
	return []string{"id", "name", "description", "year", "manufacturer", "manufacturer_website"}
}

func GetRandomGood(maxRating float32) Goods {
	t := Goods{}

	err := faker.FakeData(&t)
	if err != nil {
		panic(err)
	}

	return t
}
