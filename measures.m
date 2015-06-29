
function evaluated_stat = measures(gt, seg, method)
% ------------------------------------------------------------------------
% evaluated_stat = evalseg(gt,seg,method)
% 
% Compute different segmentation statistics. 
%
%   gt = Binary 3D image containing the ground-truth data.
%   seg = binary 3D image containing the estimated segmentation mask
%   method = Evalutation method:
%       'dsc' : Dice Similarity Coefficient
%       'aov' : Area d'Overlap
%       'tpf' : True Positive Fraction
%       'tnf' : True Negative Fraction
%       ....
%       ....
%       'full' : Compute all the evaluation stats reported above
%
%   True positive / False positive / False Negative can be computed voxelwise 
%   or regiowise also:
%
%       'rfnf' : not detected lesion regions / total lesion
%                regions (gt)
%       'rtpf' : true detected lesion regions / total lesion
%                regions (gt)
%       'rfpf' : false detected lesion regions / total lesion
%                regions (gt)
%
%  June 2015 Sergi Valverde / Mariano Cabezas
%  sergi.valverde@udg.edu
% ------------------------------------------------------------------------
  

% Function initialization
if nargin<2,
    error('Uhmm.. looks like the number of parameters is incorrect...');
elseif nargin==2,
    method='dsc';
    voxelwise = 1;
end

% -----------------------------------------------
% voxelwise evaluation (M.Cabezas implementation)
% -----------------------------------------------

ne=numel(gt);

% true positive fraction
tpf = sum(reshape(gt&seg,ne,1))/sum(reshape(gt,ne,1)); 
% true negative fraction
tnf = sum(reshape(~gt&~seg,ne,1))/sum(reshape(~gt,ne,1));    
% false positive fraction
fpf = sum(reshape(~gt&seg,ne,1))/ (sum(reshape(~gt,ne,1))); 
% false negative fraction
fnf = sum(reshape(gt&~seg,ne,1))/sum(reshape(gt,ne,1));      
% Area overlap
aov = sum(reshape(gt&seg,ne,1))/sum(reshape(gt|seg,ne,1));   
% Sensitivity
sens = sum(reshape(gt&seg,ne,1)) / (sum(reshape(gt&seg,ne,1))+sum(reshape(gt&~seg,ne,1))); 
% Dice coefficient
dsc = 2*(sum(reshape(seg&gt,ne,1))) / (sum(reshape(seg,ne,1))+sum(reshape(gt,ne,1))); 

% Specificity
%spec = (sum(reshape(~gt&~seg,ne,1)) - back_voxels) / ((sum(reshape(~gt&~seg,ne,1)) - back_voxels) +sum(reshape(~gt&seg,ne,1))); 
% Precision
%prec = sum(reshape(gt&seg,ne,1)) / (sum(reshape(gt&seg,ne,1))+sum(reshape(~gt&seg,ne,1))); 
% Recall
%rec = sum(reshape(~gt&~seg,ne,1)) / (sum(reshape(~gt&~seg,ne,1))+sum(reshape(gt&~seg,ne,1))); 
% Tanimoto coefficient
%tn = (sum(reshape(gt&seg,ne,1))+sum(reshape(~(gt|seg),ne,1)))/(sum(reshape(gt|seg,ne,1))+sum(reshape(~(gt&seg),ne,1))); % Tanimoto
% Volume similarity
%vs = 1 - sum(sum(gt(:))-sum(seg(:)))/(sum(gt(:))+sum(seg(:)));       % Volume Similarity


% -----------------------------------------------
% Regionwise evaluation 
% -----------------------------------------------

%region-wise evaluation:
% number of lesions in 3D
seg_lesions = bwconncomp(seg,6);
gt_lesions = bwconncomp(gt,6);

num_gt_lesions = gt_lesions.NumObjects;

% true positive regions divided by the number of lesions in the gt
rtpf = sum(cellfun(@(x) sum(seg(x) & gt(x)) >0, gt_lesions.PixelIdxList)) / num_gt_lesions;
% false negative regions divided by the number of lesions in the gt
rfnf = sum(cellfun(@(x) sum(seg(x) & gt(x)) == 0, gt_lesions.PixelIdxList)) / num_gt_lesions;
% false positive regions divided by the number of lesions in the gt
rfpf = sum(cellfun(@(x) sum(seg(x) & gt(x)) == 0, seg_lesions.PixelIdxList)) / num_gt_lesions;
   
% -----------------------------------------------
% Choose the method given the input
% -----------------------------------------------

switch lower(method)
    case 'tpf'
        evaluated_stat = tpf;
    case 'tnf'
        evaluated_stat = tnf;
    case 'fpf'
        evaluated_stat = fpf;
    case 'fnf'
        evaluated_stat = fnf;    
    case 'aov'
        evaluated_stat = aov;
    case 'dsc'
        evaluated_stat = dsc;
    case 'tn'
        evaluated_stat = tn;
    case 'vs'
        evaluated_stat = vs;
    case 'sens'
        evaluated_stat = sens;
    case 'spec'
        evaluated_stat =spec;
    case 'prec'
        evaluated_stat =prec;
    case 'rec'
        evaluated_stat =rec;
    case 'rfpf'
        evaluated_stat =rfpf;
    case 'rfnf'
        evaluated_stat =rfnf;
    case 'rtpf'
        evaluated_stat =rtpf;
        
        
    case 'full'
        evaluated_stat.dsc = dsc;
        evaluated_stat.aov = aov;
        evaluated_stat.tpf = tpf;
        evaluated_stat.tnf = tnf;
        evaluated_stat.fpf = fpf;
        evaluated_stat.aov = aov;
        evaluated_stat.rtpf = rtpf;
        evaluated_stat.rfnf = rfnf;
        evaluated_stat.rfpf = rfpf;
    otherwise
        evaluated_stat=[];

end
