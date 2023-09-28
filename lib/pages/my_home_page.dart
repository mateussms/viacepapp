import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:viacepapp/pages/via_cep_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin  {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          ViaCepPage()
        ],
      ),bottomNavigationBar: ConvexAppBar.badge(
        const {},// with TickerProviderStateMixin
        items: const [
          TabItem(icon: Icons.house, title: 'Lista')
        ],
        onTap: (int i) => tabController.index = i,
        controller: tabController,
      ),
    );
  }
}
