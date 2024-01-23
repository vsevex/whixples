import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:ping/cubit/cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final jid = useState<String>('');
    final password = useState<String>('');
    final ping = useState<String>('');

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (!state.isConnected)
                  Column(
                    children: <Widget>[
                      TextFormField(
                        onChanged: (value) => jid.value = value,
                        decoration:
                            const InputDecoration(hintText: 'Jabber ID'),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        onChanged: (value) => password.value = value,
                        decoration: const InputDecoration(hintText: 'Password'),
                      ),
                      const SizedBox(height: 10),
                    ],
                  )
                else
                  TextFormField(
                    onChanged: (value) => ping.value = value,
                    decoration: const InputDecoration(
                      hintText: 'JID to ping...',
                    ),
                  ),
                const SizedBox(height: 10),
                if (state.isConnected)
                  ElevatedButton(
                    onPressed: ping.value.isNotEmpty
                        ? () => BlocProvider.of<HomeCubit>(context)
                            .sendPing(ping.value)
                        : null,
                    child: state.pinging
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          )
                        : const Text('Send ping'),
                  )
                else
                  ElevatedButton(
                    onPressed:
                        (jid.value.isNotEmpty && password.value.isNotEmpty)
                            ? () => BlocProvider.of<HomeCubit>(context)
                                .initialize(
                                  jabberID: jid.value,
                                  password: password.value,
                                )
                                .connect()
                            : null,
                    child: state.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          )
                        : const Text('Connect to the Server'),
                  ),
                if (state.pingedJID != null)
                  Text(
                    !state.pingFailed
                        ? 'Pinged ${state.pingedJID}'
                        : 'Failed to ping ${state.pingedJID}',
                    style: TextStyle(
                      color: state.pingFailed ? Colors.red : Colors.green,
                    ),
                  )
                else
                  const SizedBox.square(dimension: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
