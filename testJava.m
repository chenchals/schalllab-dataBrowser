clear all
javarmpath('/Users/subravcr/GitHub/JavaScala/metadata/target/metadata-0.0.1-SNAPSHOT.jar')
javaaddpath('/Users/subravcr/GitHub/JavaScala/metadata/target/metadata-0.0.1-SNAPSHOT.jar')

import vandy.neuro.metadata.Subject;

ad=javaArray('java.lang.Double',5);
for i=1:5
    ad(i)=java.lang.Double(i*2);
end

hm=java.util.HashMap;
hm.put('key#1','my String');
hm.put('key#2', '[1000,10]');


cint32=arrayfun(@(x) x,uint32(1:10),'UniformOutput',false);


eulerFolder='/Users/subravcr/teba-local/schalllab/data/Euler/mat';
datafile= Datafile([eulerFolder,filesep,'eulsef20120911a.mat']);


z=Subject

