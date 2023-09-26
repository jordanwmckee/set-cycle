package models

import (
	"errors"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/jordanwmckee/set-cycle/utils/db"
	"gorm.io/gorm"
)

type Plan struct {
	gorm.Model
	UserID      string
	Position    int        `gorm:"not null" json:"position"`
	Name        string     `gorm:"size:100;not null" json:"name"`
	Description string     `gorm:"size:255;not null" json:"description"`
	Exercises   []Exercise `gorm:"foreignKey:PlanID" json:"exercises"`
}

type Exercise struct {
	gorm.Model
	PlanID   uint
	Position int    `gorm:"not null" json:"position"`
	Name     string `gorm:"size:100;not null" json:"name"`
	Video    string `gorm:"size:255;not null" json:"video"`
	Reps     []Rep  `gorm:"foreignKey:ExerciseID" json:"reps"`
}

type Rep struct {
	gorm.Model
	ExerciseID uint
	Weight     int `json:"weight"`
	Reps       int `json:"reps"`
}

// ExtractPlanID extracts the plan id from the request
func ExtractPlanID(c *gin.Context) (uint, error) {
	plan_id, err := strconv.Atoi(c.Param("plan_id"))

	if err != nil {
		return 0, err
	}

	return uint(plan_id), nil
}

// GetPlan returns one plan from the database for the given user with the given plan id
func GetPlan(uid string, pid uint) (*Plan, error) {
	var plan Plan

	// get the entire plan, including its associations using Preload
	DB := db.GetDB()
	err := DB.Preload("Exercises.Reps").Where("id = ? AND user_id = ?", pid, uid).First(&plan).Error

	if err != nil {
		return nil, err
	}

	return &plan, nil
}

// GetPlansForUser returns all plans from the database for the given user
func GetPlans(uid string) ([]Plan, error) {
	var plans []Plan

	// Use Preload to include associated exercises and reps and order by "position" field in ascending order
	DB := db.GetDB()
	if err := DB.Preload("Exercises.Reps").Where("user_id = ?", uid).Order("position asc").Find(&plans).Error; err != nil {
		return []Plan{}, err
	}

	return plans, nil
}

// SavePlan saves a plan to the database and associates it with the given user
func (p *Plan) CreateNewPlanForUser(uid string) (*Plan, error) {
	// make sure the plan is associated with the user id
	p.UserID = uid

	// find the highest position number for this user's plans
	var maxPosition int
	DB := db.GetDB()
	DB.Model(&Plan{}).Where("user_id = ?", uid).Select("MAX(position)").Scan(&maxPosition)

	// set the position number for this plan to one higher than the highest position number
	p.Position = maxPosition + 1

	// set order of exercises
	for i, exercise := range p.Exercises {
		exercise.Position = i + 1
	}

	// save the plan to the database
	if err := DB.Create(p).Error; err != nil {
		return &Plan{}, err
	}

	return p, nil
}

// PlanExists checks if a plan exists in the database and the user id matches the given user id
func (p *Plan) PlanExistsForUser(uid string) (bool, error) {
	var count int64

	DB := db.GetDB()
	if err := DB.Model(&Plan{}).Where("id = ? AND user_id = ?", p.ID, uid).Count(&count).Error; err != nil {
		return false, err
	}

	return count > 0, nil
}

// ModifyExistingPlanInDB modifies an existing plan in the database if it exists.
func (p *Plan) ModifyPlanForUser(uid string) (*Plan, error) {
	exists, err := p.PlanExistsForUser(uid)

	if err != nil {
		return &Plan{}, err
	}

	if !exists {
		return &Plan{}, errors.New("plan does not exist")
	} else {
		// Plan exists, update it
		DB := db.GetDB()
		DB.Session(&gorm.Session{FullSaveAssociations: true}).Updates(&p)
	}

	return p, nil
}

// UpdatePlanPosition updates the position of a plan in the database if it exists,
// and updates the position of all other plans for the user accordingly.
func UpdatePlanPosition(uid string, pid uint, newPosition int) error {
	// Get the plan with the given pid from the database
	plan, err := GetPlan(uid, pid)
	if err != nil {
		return err
	}

	// Validate that the plan exists for the user
	if exists, _ := plan.PlanExistsForUser(uid); !exists {
		return errors.New("plan does not exist")
	}

	// Update the position of the plan
	DB := db.GetDB()
	DB.Model(&plan).Update("position", newPosition)

	// Get all plans for the user
	plans, err := GetPlans(uid)
	if err != nil {
		return err
	}

	// Update the position of all plans for the user where the position is greater than the new position
	for _, plan := range plans {
		if plan.Position >= newPosition && plan.ID != pid {
			DB.Model(&plan).Update("position", plan.Position+1)
		}
	}

	return nil
}

// DeletePlanForUser deletes a plan from the database if it exists and
// shifts the position of all other plans for the user accordingly.
func DeletePlanForUser(uid string, pid uint) error {
	// Get the plan with the given pid from the database
	plan, err := GetPlan(uid, pid)
	if err != nil {
		return err
	}

	// Validate that the plan exists for the user
	if exists, _ := plan.PlanExistsForUser(uid); !exists {
		return errors.New("plan does not exist")
	}

	// Delete the plan from the database
	DB := db.GetDB()
	DB.Delete(&plan)

	// Get all plans for the user
	plans, err := GetPlans(uid)
	if err != nil {
		return err
	}

	// Decrement the position of all plans with an position greater than the deleted plan
	for _, plan := range plans {
		if plan.Position > int(pid) {
			DB.Model(&plan).Update("position", plan.Position-1)
		}
	}

	return nil
}
