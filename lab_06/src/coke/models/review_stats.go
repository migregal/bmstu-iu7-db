package models

import "fmt"

type ReviewStatsReq struct {
	Period string  `json:"period"`
	Step   string  `json:"step"`
	Low    float32 `json:"low"`
	High   float32 `json:"high"`
}

func (p ReviewStats) GetRequest(step string, low, high float32) []string {
	return []string{
		fmt.Sprintf("EXTRACT('%s' FROM date_trunc('%s', reviews.date)) \"date\"", step, step),
		"AVG(get_avg_review_rating(reviews.shop_rating, reviews.good_rating, reviews.employee_rating)) average",
		fmt.Sprintf("count(*) FILTER "+
			"(WHERE get_avg_review_rating("+
			"reviews.shop_rating, "+
			"reviews.good_rating, "+
			"reviews.employee_rating) < %f) negative", low),
		fmt.Sprintf("count(*) FILTER "+
			"(WHERE get_avg_review_rating("+
			"reviews.shop_rating, "+
			"reviews.good_rating, "+
			"reviews.employee_rating) between %f and %f) neutral", low, high),
		fmt.Sprintf("count(*) FILTER ("+
			"WHERE get_avg_review_rating("+
			"reviews.shop_rating,"+
			"reviews.good_rating,"+
			"reviews.employee_rating) > %f) positive", high)}
}

func (p ReviewStats) GetWhere(period string) string {
	return fmt.Sprintf("date_part('%s', reviews.date) = date_part('%s', CURRENT_DATE)", period, period)
}

func (p ReviewStats) GetGroupBy(step string) string {
	return fmt.Sprintf("date_trunc('%s', reviews.date)", step)
}

func (p ReviewStats) GetOrderBy(step string) string {
	return fmt.Sprintf("date_trunc('%s', reviews.date)", step)
}

type ReviewStats struct {
	Date     string `db:"date" json:"date"`
	Average  string `db:"average" select:"average" json:"average"`
	Negative string `db:"negative" json:"negative"`
	Neutral  string `db:"neutral" json:"neutral"`
	Positive string `db:"positive" json:"positive"`
	Total    string `db:"total" json:"total"`
}

func (p ReviewStats) TableName() string {
	return "reviews"
}
