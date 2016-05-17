--require "view/taskDialog/TaskDialogWin"

CTaskDialogController = class();
--判断是否能把子容器添加到父类里
function CTaskDialogController.addNode( parent1 , node1)
    if( node1 and parent1 and node1 : getParent() ~= parent1) then
        parent1 : addChild ( node1 );
    end
    node1 : setVisible ( true )    
end




--判断是否能移除子级
--[[
function CTaskDialogController.removeNode(parent1 , node1)
    if( node1 and parent1 and node1 : getParent() == parent1) then
        parent1 : removeChild ( node1 );
    end
end
 ]]




