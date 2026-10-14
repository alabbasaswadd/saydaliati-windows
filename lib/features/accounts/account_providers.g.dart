// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition root for دليل الحسابات — online-only (see [AccountRepository] doc).

@ProviderFor(accountRemoteDataSource)
final accountRemoteDataSourceProvider = AccountRemoteDataSourceProvider._();

/// Composition root for دليل الحسابات — online-only (see [AccountRepository] doc).

final class AccountRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AccountRemoteDataSource,
          AccountRemoteDataSource,
          AccountRemoteDataSource
        >
    with $Provider<AccountRemoteDataSource> {
  /// Composition root for دليل الحسابات — online-only (see [AccountRepository] doc).
  AccountRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AccountRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountRemoteDataSource create(Ref ref) {
    return accountRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountRemoteDataSource>(value),
    );
  }
}

String _$accountRemoteDataSourceHash() =>
    r'363608143ccdacd17a6156684a25b86651df3f64';

@ProviderFor(accountRepository)
final accountRepositoryProvider = AccountRepositoryProvider._();

final class AccountRepositoryProvider
    extends
        $FunctionalProvider<
          AccountRepository,
          AccountRepository,
          AccountRepository
        >
    with $Provider<AccountRepository> {
  AccountRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountRepositoryHash();

  @$internal
  @override
  $ProviderElement<AccountRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountRepository create(Ref ref) {
    return accountRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountRepository>(value),
    );
  }
}

String _$accountRepositoryHash() => r'd74f0477af833f87cbc9cc7e600e4dd5d7ca9f8b';

@ProviderFor(accountsList)
final accountsListProvider = AccountsListProvider._();

final class AccountsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Account>>,
          List<Account>,
          FutureOr<List<Account>>
        >
    with $FutureModifier<List<Account>>, $FutureProvider<List<Account>> {
  AccountsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountsListHash();

  @$internal
  @override
  $FutureProviderElement<List<Account>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Account>> create(Ref ref) {
    return accountsList(ref);
  }
}

String _$accountsListHash() => r'bff07bfc60ff2982bca3d9de22b76dfbbc3dfb66';

@ProviderFor(accountStatement)
final accountStatementProvider = AccountStatementFamily._();

final class AccountStatementProvider
    extends
        $FunctionalProvider<
          AsyncValue<AccountStatement>,
          AccountStatement,
          FutureOr<AccountStatement>
        >
    with $FutureModifier<AccountStatement>, $FutureProvider<AccountStatement> {
  AccountStatementProvider._({
    required AccountStatementFamily super.from,
    required (String, {DateTime? from, DateTime? to}) super.argument,
  }) : super(
         retry: null,
         name: r'accountStatementProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$accountStatementHash();

  @override
  String toString() {
    return r'accountStatementProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<AccountStatement> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AccountStatement> create(Ref ref) {
    final argument = this.argument as (String, {DateTime? from, DateTime? to});
    return accountStatement(
      ref,
      argument.$1,
      from: argument.from,
      to: argument.to,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AccountStatementProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$accountStatementHash() => r'a57ab6c367fb46ccfe349c822b7952bd37a1279c';

final class AccountStatementFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<AccountStatement>,
          (String, {DateTime? from, DateTime? to})
        > {
  AccountStatementFamily._()
    : super(
        retry: null,
        name: r'accountStatementProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AccountStatementProvider call(
    String accountId, {
    DateTime? from,
    DateTime? to,
  }) => AccountStatementProvider._(
    argument: (accountId, from: from, to: to),
    from: this,
  );

  @override
  String toString() => r'accountStatementProvider';
}
