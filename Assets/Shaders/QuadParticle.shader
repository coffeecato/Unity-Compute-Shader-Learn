﻿Shader "Custom/QuadParticle" {
	Properties     
    {
        _MainTex("Texture", 2D) = "white" {}     
    }  

	SubShader {
		Pass {
		Tags{ "Queue"="Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" }
		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off
//			Tags{ "RenderType" = "Opaque" }
//			LOD 200
//			Blend SrcAlpha one
		
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		#include "UnityCG.cginc"

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 5.0

	    struct Vertex
		{
	        float3 position;
	        float2 uv;
	        float life;
	    };
	    StructuredBuffer<Vertex> vertexBuffer;
		struct v2f
		{
			float4 position : SV_POSITION;
			float4 color : COLOR;
			float2 uv: TEXCOORD0;
		};

		sampler2D _MainTex;
		
		v2f vert(uint vertex_id : SV_VertexID, uint instance_id : SV_InstanceID)
		{
	        v2f o = (v2f)0;
	        int index = instance_id*6 + vertex_id;
	        float lerpVal = vertexBuffer[index].life * 0.25f;
	        o.color = fixed4(1.0f - lerpVal+0.1, lerpVal+0.1, 1.0f, lerpVal);
	        o.position = UnityWorldToClipPos(float4(vertexBuffer[index].position, 1.0f));
			o.uv = vertexBuffer[index].uv;
	        return o;
		}

		float4 frag(v2f i) : COLOR
		{
			fixed4 color = tex2D( _MainTex, i.uv ) * i.color;
			return color;
		}


		ENDCG
		}
	}
	FallBack Off
}
