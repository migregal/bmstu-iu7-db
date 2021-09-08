package structs

import (
	"github.com/bxcodec/faker/v3"
)

type Users struct {
	Id         string `faker:"uuid_hyphenated,unique"`
	FirstName  string `faker:"first_name"`
	LastName   string `faker:"last_name"`
	Email      string `faker:"email,unique"`
	Phone      string `faker:"phone_number,unique"`
	Registered string `faker:"date"`
}

func (s Users) ToSlice() []string {
	return []string{s.Id, s.FirstName, s.LastName, s.Email, s.Phone, s.Registered}
}

func GetUsersHeaders() []string {
	return []string{"id", "first_name", "last_name", "email", "phone", "registered"}
}

func GetRandomUsers() Users {
	t := Users{}

	err := faker.FakeData(&t)
	if err != nil {
		panic(err)
	}

	return t
}
