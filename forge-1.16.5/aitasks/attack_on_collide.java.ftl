<#include "aiconditions.java.ftl">
this.goalSelector.addGoal(${customBlockIndex+1}, new MeleeAttackGoal(this, ${field$speed}, ${field$longmemory?lower_case}) {

	@Override protected double getAttackReachSqr(LivingEntity entity) {
		return this.mob.getWidth() * this.mob.getWidth() + entity.getWidth();
    }

    <@conditionCode field$condition false/>

});
