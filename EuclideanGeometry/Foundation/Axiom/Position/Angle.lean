import EuclideanGeometry.Foundation.Axiom.Linear.Ray

noncomputable section
namespace EuclidGeom
/- Define values of oriented angles, in (-π, π], modulo 2 π. -/
/- Define oriented angles, ONLY taking in two rays starting at one point!  And define ways to construct oriented angles, by given three points on the plane, and etc.  -/
@[ext]
class OAngle (P : Type _) [EuclideanPlane P] where 
  start_ray : Ray P
  end_ray : Ray P
  source_eq_source : start_ray.source = end_ray.source

namespace OAngle

variable {P : Type _} [EuclideanPlane P] 

def mk_pt_pt_pt (A O B : P) (h₁ : A ≠ O) (h₂ : B ≠ O): OAngle P where
  start_ray := Ray.mk_pt_pt O A h₁
  end_ray := Ray.mk_pt_pt O B h₂
  source_eq_source := rfl

def mk_ray_pt (ray : Ray P) (A : P) (h : A ≠ ray.source ) : OAngle P where
  start_ray := ray
  end_ray := Ray.mk_pt_pt ray.source A h
  source_eq_source := rfl

def value (A : OAngle P): ℝ := Dir.angle (A.start_ray.toDir) (A.end_ray.toDir)

def angle_of_three_point_nontriv (A O B : P) (h₁ : A ≠ O) (h₂ : B ≠ O): ℝ := 
(OAngle.mk_pt_pt_pt _ _ _ h₁ h₂).value

def angle_of_two_ray_of_eq_source (start_ray end_ray : Ray P) (h : start_ray.source = end_ray.source) : ℝ := (OAngle.mk start_ray end_ray h).value

def is_nd (oang : OAngle P) : Prop := oang.value ≠ 0 ∧ oang.value ≠ π 

protected def source (oang : OAngle P) : P := oang.start_ray.source

end OAngle

scoped notation "OANG" => OAngle.mk_pt_pt_pt

scoped notation "ANG" => OAngle.angle_of_three_point_nontriv

scoped notation "∠" => OANG 

namespace OAngle

variable {P : Type _} [EuclideanPlane P] 

-- `should discuss this later, is there a better definition?` ite, dite is bitter to deal with
/- `What does it mean to be LiesIn a oangle? when the angle < 0`, for now it is defined as the smaller side. and when angle = π, it is defined as the left side -/

protected def IsInt (p : P) (oang : OAngle P) : Prop := by
  by_cases p = oang.source
  · exact False
  · let ray := Ray.mk_pt_pt oang.source p h
    let o₁ := OAngle.mk oang.start_ray ray rfl
    let o₂ := OAngle.mk ray oang.end_ray (oang.3)
    exact if oang.value > 0 then (o₁.value > 0 ∧ o₂.value > 0) else (o₁.value < 0 ∧ o₂.value < 0) 

protected def interior (oang : OAngle P) : Set P := { p : P | OAngle.IsInt p oang }

instance : Interior P (OAngle P) where
  interior := fun o => o.interior

end OAngle

/- theorem - π < angle.value, angle.value ≤ π,  -/

/- theorem when angle > 0, IsInt means lies left of start ray + right of end ray; when angle < 0, ...  -/

/- Operations on oriented angles, such a additivity of the evaluation of oriented angles.  -/
/- theorem l1 l2 l3 add angle; sub angle -/
/- theorem O A B C add angle; sub angle-/

/- 90 degree -/

end EuclidGeom