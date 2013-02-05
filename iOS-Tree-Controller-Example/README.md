iOS-Tree-Component
==================

The iOS Tree component is a UITableViewCell replacement that lets your UITableView works as a tree. The component is very simple to use it contains two classes and a nib file. It is developed using ARC, and works on either storyboards or nib files it was actually tested only on storyboards, but I suppose it will ork in both :).
To use this control just make your prototype cell’s identifier equals to “treeNodeCell” and supply you UITableView’s datasource with an array of TreeViewNode objects that contain the nodes you want to display. The TreeViewNode class contains a nodeData object that can hold the actual data you want to display in the tree.


You can check out this control in action in my iPad project:
http://itunes.apple.com/app/the-projects/id477290956?mt=8
