package models

import (
	"errors"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/jordanwmckee/set-cycle/utils/db"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type Plan struct {
	gorm.Model
	UserID      string
	Name        string     `gorm:"size:100;not null" json:"name"`
	Description string     `gorm:"size:255;not null" json:"description"`
	Exercises   []Exercise `gorm:"foreignKey:PlanID" json:"exercises"`
}

type Exercise struct {
	gorm.Model
	PlanID uint
	Name   string `gorm:"size:100;not null" json:"name"`
	Video  string `gorm:"size:255;not null" json:"video"`
	Reps   []Rep  `gorm:"foreignKey:ExerciseID" json:"reps"`
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

	// Use Preload to include associated exercises and reps
	DB := db.GetDB()
	if err := DB.Preload("Exercises.Reps").Where("user_id = ?", uid).Find(&plans).Error; err != nil {
		return []Plan{}, err
	}

	return plans, nil
}

// SavePlan saves a plan to the database and associates it with the given user
func (p *Plan) CreateNewPlanForUser(uid string) (*Plan, error) {
	// make sure the plan is associated with the user id
	p.UserID = uid

	// save the plan to the database
	DB := db.GetDB()
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

// DeletePlanForUser deletes a plan from the database if it exists.
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
	err = DB.Select(clause.Associations).Delete(&plan).Error

	if err != nil {
		return err
	}

	return nil
}
