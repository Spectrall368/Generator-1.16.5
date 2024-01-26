<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "procedures.java.ftl">
package ${package}.client.particle;
<#compress>

@OnlyIn(Dist.CLIENT) public class ${name}Particle extends SpriteTexturedParticle {

	public static ${name}IParticleFactory factory(IAnimatedSprite spriteSet) {
		return new ${name}IParticleFactory(spriteSet);
	}

	@OnlyIn(Dist.CLIENT) public static class ${name}IParticleFactory implements IParticleFactory<BasicParticleType> {
		private final IAnimatedSprite spriteSet;

		public ${name}IParticleFactory(IAnimatedSprite spriteSet) {
			this.spriteSet = spriteSet;
		}

		public Particle makeParticle(BasicParticleType typeIn, ClientWorld worldIn, double x, double y, double z, double xSpeed, double ySpeed, double zSpeed) {
			return new ${name}Particle(worldIn, x, y, z, xSpeed, ySpeed, zSpeed, this.spriteSet);
		}
	}

	private final IAnimatedSprite spriteSet;
	
	<#if data.angularVelocity != 0 || data.angularAcceleration != 0>
	private float angularVelocity;
	private float angularAcceleration;
	</#if>

	protected ${name}Particle(ClientWorld world, double x, double y, double z, double vx, double vy, double vz, IAnimatedSprite spriteSet) {
		super(world, x, y, z);
		this.spriteSet = spriteSet;

		this.setSize(${data.width}f, ${data.height}f);
		<#if data.scale != 1>this.particleScale *= ${data.scale}f;</#if>

		<#if (data.maxAgeDiff > 0)>
		this.maxAge = (int) Math.max(1, ${data.maxAge} + (this.rand.nextInt(${data.maxAgeDiff * 2}) - ${data.maxAgeDiff}));
		<#else>
		this.maxAge = ${data.maxAge};
		</#if>

		this.particleGravity = ${data.gravity}f;
		this.canCollide = ${data.canCollide};

		this.motionX = vx * ${data.speedFactor};
		this.motionY = vy * ${data.speedFactor};
		this.motionZ = vz * ${data.speedFactor};

		<#if data.angularVelocity != 0 || data.angularAcceleration != 0>
		this.angularVelocity = ${data.angularVelocity}f;
		this.angularAcceleration = ${data.angularAcceleration}f;
		</#if>

		<#if data.animate>
		this.selectSpriteWithAge(spriteSet);
		<#else>
		this.selectSpriteRandomly(spriteSet);
		</#if>
	}

	<#if data.renderType == "LIT">
	@Override public int getBrightnessForRender(float partialTick) {
		return 15728880;
	}
	</#if>

	@Override public IParticleRenderType getRenderType() {
		return IParticleRenderType.PARTICLE_SHEET_${data.renderType};
	}

	@Override public void tick() {
		super.tick();

		<#if data.angularVelocity != 0 || data.angularAcceleration != 0>
		this.prevParticleAngle = this.particleAngle;
		this.particleAngle += this.angularVelocity;
		this.angularVelocity += this.angularAcceleration;
		</#if>

		<#if data.animate>
		if(!this.isExpired) {
			<#assign frameCount = data.getTextureTileCount()>
			this.setSprite(this.spriteSet.get((this.age / ${data.frameDuration}) % ${frameCount} + 1, ${frameCount}));
		}
		</#if>

		<#if hasProcedure(data.additionalExpiryCondition)>
		World world = this.world;
		if (<@procedureOBJToConditionCode data.additionalExpiryCondition/>)
			this.setExpired();
		</#if>
	}
}
</#compress>
<#-- @formatter:on -->
