<#-- @formatter:off -->
<#include "aiconditions.java.ftl">
this.goalSelector.addGoal(${cbi+1}, new RandomWalkingGoal(this, ${field$speed}, 20) {

    @Override protected Vector3d getPosition() {
		Random random = ${name}Entity.this.getRNG();
		double dir_x = ${name}Entity.this.getPosX() + ((random.nextFloat() * 2 - 1) * 16);
		double dir_y = ${name}Entity.this.getPosY() + ((random.nextFloat() * 2 - 1) * 16);
		double dir_z = ${name}Entity.this.getPosZ() + ((random.nextFloat() * 2 - 1) * 16);
		return new Vector3d(dir_x, dir_y, dir_z);
	}

	<@conditionCode field$condition false/>

});
<#-- @formatter:on -->
