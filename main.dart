import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const App3105());

class App3105 extends StatelessWidget {
  const App3105({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: '3105',
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: const Color(0xFF090A0D),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.red, brightness: Brightness.dark),
    ),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget { const HomePage({super.key}); @override State<HomePage> createState()=>_HomePageState(); }
class _HomePageState extends State<HomePage> {
  int tab=0; bool running=false; String keyText='DEMO-3105-XXXX'; DateTime expiry=DateTime.now().add(const Duration(days:30));
  final List<Map<String,dynamic>> files=[];

  Future<void> pickFiles() async {
    final r=await FilePicker.platform.pickFiles(allowMultiple:true);
    if(r==null)return;
    setState(()=>files.addAll(r.files.map((f)=>{'name':f.name,'enabled':true})));
  }
  Future<void> saveKey() async { final p=await SharedPreferences.getInstance(); await p.setString('key',keyText); }
  void keyDialog(){
    final c=TextEditingController(text:keyText);
    showDialog(context:context,builder:(_)=>AlertDialog(title:const Text('Key / Expiry'),content:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:c,decoration:const InputDecoration(labelText:'Key')),const SizedBox(height:12),Text('หมดอายุ: ${expiry.day}/${expiry.month}/${expiry.year}')]),actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('ยกเลิก')),FilledButton(onPressed:(){setState(()=>keyText=c.text.trim());saveKey();Navigator.pop(context);},child:const Text('บันทึก'))]));
  }
  @override Widget build(BuildContext context){
    final titles=['Dashboard','Files','Tools','Settings'];
    return Scaffold(appBar:AppBar(title:Text('3105 • ${titles[tab]}'),actions:[IconButton(onPressed:keyDialog,icon:const Icon(Icons.key)),IconButton(onPressed:()=>setState(()=>running=!running),icon:Icon(running?Icons.stop_circle_outlined:Icons.play_circle_outline))]),
      body: tab==0?_dashboard():tab==1?_files():tab==2?_tools():_settings(),
      bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(i)=>setState(()=>tab=i),destinations:const[NavigationDestination(icon:Icon(Icons.dashboard_outlined),label:'Home'),NavigationDestination(icon:Icon(Icons.folder_outlined),label:'Files'),NavigationDestination(icon:Icon(Icons.tune),label:'Tools'),NavigationDestination(icon:Icon(Icons.settings_outlined),label:'Settings')]),
    );
  }
  Widget _card(Widget child)=>Card(color:const Color(0xFF121419),margin:const EdgeInsets.only(bottom:12),child:Padding(padding:const EdgeInsets.all(16),child:child));
  Widget _dashboard()=>ListView(padding:const EdgeInsets.all(16),children:[
    _card(Row(children:[ClipRRect(borderRadius:BorderRadius.circular(12),child:Image.asset('assets/app_icon.png',width:56,height:56)),const SizedBox(width:14),const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('3105',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold)),Text('Control Center • Rebuild',style:TextStyle(color:Colors.white54))])),Icon(running?Icons.check_circle:Icons.pause_circle, color:running?Colors.green:Colors.orange)])),
    _card(Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('ACCESS KEY',style:TextStyle(color:Colors.white54)),const SizedBox(height:6),Text(keyText,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w600)),const SizedBox(height:4),Text('หมดอายุ ${expiry.day}/${expiry.month}/${expiry.year}',style:const TextStyle(color:Colors.white60)),const SizedBox(height:12),SizedBox(width:double.infinity,child:FilledButton.icon(onPressed:keyDialog,icon:const Icon(Icons.lock_open),label:const Text('MANAGE KEY')))])),
    _card(Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('QUICK ACTIONS',style:TextStyle(color:Colors.white54)),const SizedBox(height:12),Wrap(spacing:8,runSpacing:8,children:[_chip('Import File',Icons.file_upload,pickFiles),_chip('File Manager',Icons.folder,()=>setState(()=>tab=1)),_chip('Tools',Icons.tune,()=>setState(()=>tab=2))])]))
  ]);
  Widget _chip(String t,IconData i,VoidCallback f)=>ActionChip(avatar:Icon(i,size:18),label:Text(t),onPressed:f);
  Widget _files()=>ListView(padding:const EdgeInsets.all(16),children:[_card(Row(children:[const Expanded(child:Text('My Files',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold))),FilledButton.icon(onPressed:pickFiles,icon:const Icon(Icons.add),label:const Text('Add'))])),if(files.isEmpty)_card(const Center(child:Padding(padding:EdgeInsets.all(24),child:Text('ยังไม่มีไฟล์\nกด Add เพื่อเลือกไฟล์จากเครื่อง',textAlign:TextAlign.center)))) else ...files.asMap().entries.map((e)=>_card(ListTile(leading:const Icon(Icons.insert_drive_file),title:Text(e.value['name']),subtitle:const Text('Local file'),trailing:Switch(value:e.value['enabled'],onChanged:(v)=>setState(()=>e.value['enabled']=v)),onLongPress:()=>setState(()=>files.removeAt(e.key))))]);
  Widget _tools()=>ListView(padding:const EdgeInsets.all(16),children:[_card(const ListTile(leading:Icon(Icons.folder_copy_outlined),title:Text('File Workspace'),subtitle:Text('จัดการไฟล์ที่นำเข้าในแอป'))),_card(const ListTile(leading:Icon(Icons.language),title:Text('Language'),subtitle:Text('English / 中文 / Tiếng Việt / ไทย'))),_card(const ListTile(leading:Icon(Icons.info_outline),title:Text('About 3105 Rebuild'),subtitle:Text('UI prototype built from observable app structure')))]);
  Widget _settings()=>ListView(padding:const EdgeInsets.all(16),children:[_card(const ListTile(leading:Icon(Icons.lock_outline),title:Text('Key management'),subtitle:Text('จัดการ Key และสถานะการใช้งาน'))),_card(const ListTile(leading:Icon(Icons.delete_outline),title:Text('Clear local files'),subtitle:Text('ลบรายการไฟล์จากหน้าแอป'))),_card(const ListTile(leading:Icon(Icons.code),title:Text('Build info'),subtitle:Text('Flutter prototype • iOS 26.0+ target')))]);
}
