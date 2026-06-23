<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2024, Pylo, opensource contributors
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
<@javacompress>

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
	
	<#if data.hasAngularVelocityOrAcceleration()>
	private float angularVelocity;
	private float angularAcceleration;
	</#if>

	protected ${name}Particle(ClientWorld world, double x, double y, double z, double vx, double vy, double vz, IAnimatedSprite spriteSet) {
		super(world, x, y, z);
		this.spriteSet = spriteSet;

		this.setSize(${data.width}f, ${data.height}f);
		<#if (data.scale.getFixedValue() != 1 || data.fixedScale)  && !hasProcedure(data.scale)>
		this.particleScale <#if data.fixedScale>= 0.15f *<#else>*=</#if> ${data.scale.getFixedValue()}f;
		</#if>

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

		<#if data.hasAngularVelocityOrAcceleration()>
		this.angularVelocity = ${data.angularVelocity}f;
		this.angularAcceleration = ${data.angularAcceleration}f;
		</#if>

		<#if data.animate>
		this.selectSpriteWithAge(spriteSet);
		<#else>
		this.selectSpriteRandomly(spriteSet);
		</#if>
	}

	<#if data.emissiveRendering>
	@Override public int getBrightnessForRender(float partialTick) {
		return 15728880;
	}
	</#if>

	@Override public IParticleRenderType getRenderType() {
		return IParticleRenderType.PARTICLE_SHEET_${data.renderType};
	}

	<#if hasProcedure(data.scale)>
	@Override public float getScale(float scale) {
		return <#if data.fixedScale>0.15f<#else>super.getQuadSize(scale)</#if> * (float) <@procedureCode data.scale, {
            "x": "this.posX",
            "y": "this.posY",
            "z": "this.posZ",
            "world": "this.world",
            "age": "age",
            "scale": "scale"
        }/>
	}
	</#if>

	<#if hasProcedure(data.rotationProvider)>
	@Override public void renderParticle(IVertexBuilder buffer, ActiveRenderInfo camera, float partialTicks) {
		Vec3 vec = <@procedureCode data.rotationProvider, {
			"world": "this.world",
            "x": "this.posX",
            "y": "this.posY",
            "z": "this.posZ",
			"speedX": "this.motionX",
			"speedY": "this.motionY",
			"speedZ": "this.motionZ",
			"angularVelocity": "this.angularVelocity",
			"angularAcceleration": "this.angularAcceleration",
			"age": "this.age + partialTicks"
		}/>
		Quaternion tilt = fromXYZ((float) vec.getX(), (float) vec.getY(), (float) vec.getZ());
		this.renderRotatedQuad(buffer, camera, tilt, partialTicks);
		Quaternion flippedTilt = tilt.copy();
		flippedTilt.multiply(Vector3f.YP.rotation((float) Math.PI));
		<#-- render a flipped face because by default only a single side renders this makes particle visible from all angles -->
		this.renderRotatedQuad(buffer, camera, flippedTilt, partialTicks);
	}

	private static Quaternion fromYXZ(float y, float x, float z) {
		Quaternion quat = ONE.copy();
		quat.multiply(new Quaternion(0.0F, (float) Math.sin((double) (y / 2.0F)), 0.0F, (float) Math.cos((double) (y / 2.0F))));
		quat.multiply(new Quaternion((float) Math.sin((double) (x / 2.0F)), 0.0F, 0.0F, (float) Math.cos((double) (x / 2.0F))));
		quat.multiply(new Quaternion(0.0F, 0.0F, (float) Math.sin((double) (z / 2.0F)), (float) Math.cos((double) (z / 2.0F))));
		return quat;
	}

    private void renderRotatedQuad(IVertexBuilder buffer, ActiveRenderInfo camera, Quaternion rotation, float partialTicks) {
        Vector3d camPos = camera.getProjectedView();
        float cx = (float)(MathHelper.lerp((double) partialTicks, this.prevPosX, this.posX) - camPos.getX());
        float cy = (float)(MathHelper.lerp((double) partialTicks, this.prevPosY, this.posY) - camPos.getY());
        float cz = (float)(MathHelper.lerp((double) partialTicks, this.prevPosZ, this.posZ) - camPos.getZ());

        float size = this.getScale(partialTicks);
        float u0 = this.getMinU();
        float u1 = this.getMaxU();
        float v0 = this.getMinV();
        float v1 = this.getMaxV();
        int light = this.getBrightnessForRender(partialTicks);

        float[][] corners = { { 1,-1}, { 1, 1}, {-1, 1}, {-1,-1} };
        float[][] uvs = { {u1,v1}, {u1,v0}, {u0,v0}, {u0,v1} };

        for (int i = 0; i < 4; i++) {
            Vector3f v = new Vector3f(corners[i][0], corners[i][1], 0.0F);
            v.transform(rotation);
            v.mul(size);
            v.add(cx, cy, cz);
            buffer.pos(v.getX(), v.getY(), v.getZ())
                .tex(uvs[i][0], uvs[i][1])
                .color(this.particleRed, this.particleGreen, this.particleBlue, this.particleAlpha)
                .lightmap(light)
                .endVertex();
        }
    }
	</#if>

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
</@javacompress>
<#-- @formatter:on -->
