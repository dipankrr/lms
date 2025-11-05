// widgets/shared/responsive_layout.dart
import 'package:flutter/material.dart';
import 'sidebar.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget child;

  const ResponsiveLayout({required this.child});

  @override
  _ResponsiveLayoutState createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  bool _isSidebarCollapsed = false;
  bool _isMobile = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkScreenSize();
  }

  void _checkScreenSize() {
    final width = MediaQuery.of(context).size.width;
    setState(() {
      _isMobile = width < 768;
      if (_isMobile) _isSidebarCollapsed = true;
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarCollapsed = !_isSidebarCollapsed;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // MOBILE: Use Drawer that overlays content
    if (_isMobile) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Student Management'),
          backgroundColor: Colors.blue[800],
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: _openDrawer,
          ),
        ),
        drawer: Drawer(
          child: Sidebar(
            isCollapsed: false,
            onItemTap: _closeDrawer,
          ),
        ),
        body: widget.child,
      );
    }

    // DESKTOP/TABLET: Use foldable sidebar
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Sidebar(
            isCollapsed: _isSidebarCollapsed,
          ),

          // Content area with toggle button
          Expanded(
            child: Column(
              children: [
                // Top bar with toggle button
                Container(
                  height: 60,
                  color: Colors.grey[100],
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(_isSidebarCollapsed ? Icons.menu_open : Icons.menu),
                        onPressed: _toggleSidebar,
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),

                // Main content
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}