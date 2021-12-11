package models

type Review struct {
	ID string `db:"id" json:"id"`
}

type ReviewInfo struct {
	ShopId         string  `db:"shop_id" json:"shop_id"`
	GoodId         string  `db:"good_id" json:"good_id"`
	EmployeeId     string  `db:"employee_id" json:"employee_id"`
	ReviewerId     string  `db:"reviewer_id" json:"reviewer_id"`
	GoodRating     float32 `db:"good_rating" json:"good_rating"`
	ShopRating     float32 `db:"shop_rating" json:"shop_rating"`
	EmployeeRating float32 `db:"employee_rating" json:"employee_rating"`
}
