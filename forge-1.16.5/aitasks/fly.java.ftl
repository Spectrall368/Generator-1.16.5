<#-- @formatter:off -->
<#include "aiconditions.java.ftl">
this.goalSelector.addGoal(${cbi+1}, new RandomWalkingGoal(this, ${field$speed}, 20) {

    @Override protected Vector3d getPosition() {
		Random random = ${name}Entity.this.getRandom();
		double dir_x = ${name}Entity.this.getX() + ((random.nextFloat() * 2 - 1) * 16);
		double dir_y = ${name}Entity.this.getY() + ((random.nextFloat() * 2 - 1) * 16);
		double dir_z = ${name}Entity.this.getZ() + ((random.nextFloat() * 2 - 1) * 16);
		return new Vector3d(dir_x, dir_y, dir_z);
	}

	<@conditionCode field$condition false/>

});
<#-- @formatter:on -->
