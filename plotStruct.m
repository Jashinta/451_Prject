function plotStruct ( pStruct, depth )

for i = 1:depth
	figure;
	title('goes here');
	subplot(4,1,1); 
	plot(pStruct(i).x);
	axis([ 0 length(pStruct(i).x) min(pStruct(i).x)-1 max(pStruct(i).x)+1 ]);
	title('x axis');


	subplot(4,1,2);
	plot(pStruct(i).y);
	axis([ 0 length(pStruct(i).y) min(pStruct(i).y)-1 max(pStruct(i).y)+1 ]);
	title('y axis');
	

	subplot(4,1,3);
	plot(pStruct(i).z);
	axis([ 0 length(pStruct(i).z) min(pStruct(i).z)-1 max(pStruct(i).z)+1 ]);
	title('z axis');
	

	subplot(4,1,4);
	plot(pStruct(i).mag);
	axis([ 0 length(pStruct(i).mag) min(pStruct(i).mag)-1 max(pStruct(i).mag)+1 ]);
	title('magnitued');


	[ax,h3]=suplabel( pStruct(i).name,'t'); 
	set(h3,'FontSize',18) 

end

end