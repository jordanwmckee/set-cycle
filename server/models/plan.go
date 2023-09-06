package models

import (
	"errors"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
)

type Plan struct {
	gorm.Model
	UserID      uint       `gorm:"not null"`
	Name        string     `gorm:"not null"`
	Description string     `gorm:"not null"`
	Exercises   []Exercise `gorm:"foreignkey:PlanID;association_foreignkey:ID;on_delete:CASCADE"`
}

type Exercise struct {
	gorm.Model
	PlanID uint   `gorm:"not null"`
	Name   string `gorm:"not null"`
	Video  string `gorm:"not null"`
	Reps   []Rep  `gorm:"foreignkey:ExerciseID;association_foreignkey:ID;on_delete:CASCADE"`
}

type Rep struct {
	gorm.Model
	ExerciseID uint `gorm:"not null"`
	Weight     int  `gorm:"not null"`
	Reps       int  `gorm:"not null"`
}

/*

TODO: Issues

- modifying plan duplicates exercises
- deleting plan doesn't delete associated exercises and reps

*/

// Migrate the models to the database
func AutoMigrate(db *gorm.DB) {
	db.AutoMigrate(&User{}, &Plan{}, &Exercise{}, &Rep{})
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
func GetPlan(uid uint, pid uint) (*Plan, error) {
	var plan Plan

	err := DB.Model(&Plan{}).Where("id = ? AND user_id = ?", pid, uid).First(&plan).Error

	if err != nil {
		return nil, err
	}

	return &plan, nil
}

// GetPlansForUser returns all plans from the database for the given user
func GetPlans(uid uint) ([]Plan, error) {
	var plans []Plan

	// Use Preload to include associated exercises and reps
	if err := DB.Preload("Exercises.Reps").Where("user_id = ?", uid).Find(&plans).Error; err != nil {
		return []Plan{}, err
	}

	return plans, nil
}

// SavePlan saves a plan to the database and associates it with the given user
func (p *Plan) CreateNewPlanForUser(uid uint) (*Plan, error) {
	// make sure the plan is associated with the user id
	p.UserID = uid

	if err := DB.Create(p).Error; err != nil {
		return &Plan{}, err
	}

	return p, nil
}

// PlanExists checks if a plan exists in the database and the user id matches the given user id
func (p *Plan) PlanExistsForUser(user_id uint) (bool, error) {
	var count int

	if err := DB.Model(&Plan{}).Where("id = ? AND user_id = ?", p.ID, user_id).Count(&count).Error; err != nil {
		return false, err
	}

	return count > 0, nil
}

// ModifyExistingPlanInDB modifies an existing plan in the database if it exists.
func (p *Plan) ModifyPlanForUser(uid uint) (*Plan, error) {
	exists, err := p.PlanExistsForUser(uid)

	if err != nil {
		return &Plan{}, err
	}

	if !exists {
		return &Plan{}, errors.New("plan does not exist")
	} else {
		// Plan exists, update it
		if err := DB.Save(p).Error; err != nil {
			return &Plan{}, err
		}
	}

	return p, nil
}

// DeletePlanForUser deletes a plan from the database if it exists.
func DeletePlanForUser(uid uint, pid uint) error {
	// get the plan with given pid from db
	plan, err := GetPlan(uid, pid)

	if err != nil {
		return err
	}

	// validate the plan exists
	exists, err := plan.PlanExistsForUser(uid)

	if err != nil {
		return err
	}

	if !exists {
		return errors.New("plan does not exist")
	}

	DB.Where("user_id = ?", uid).Delete(&Plan{})
	return nil
}
