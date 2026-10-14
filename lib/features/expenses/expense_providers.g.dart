// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition root for the expenses feature — online-only (see
/// [ExpenseRepository] doc), بلا outbox ولا تخزين محلي.

@ProviderFor(expenseCategoryRemoteDataSource)
final expenseCategoryRemoteDataSourceProvider =
    ExpenseCategoryRemoteDataSourceProvider._();

/// Composition root for the expenses feature — online-only (see
/// [ExpenseRepository] doc), بلا outbox ولا تخزين محلي.

final class ExpenseCategoryRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ExpenseCategoryRemoteDataSource,
          ExpenseCategoryRemoteDataSource,
          ExpenseCategoryRemoteDataSource
        >
    with $Provider<ExpenseCategoryRemoteDataSource> {
  /// Composition root for the expenses feature — online-only (see
  /// [ExpenseRepository] doc), بلا outbox ولا تخزين محلي.
  ExpenseCategoryRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseCategoryRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseCategoryRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ExpenseCategoryRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExpenseCategoryRemoteDataSource create(Ref ref) {
    return expenseCategoryRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseCategoryRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseCategoryRemoteDataSource>(
        value,
      ),
    );
  }
}

String _$expenseCategoryRemoteDataSourceHash() =>
    r'0de5dd07cc5745284c19b4be3aad3973cdf7b232';

@ProviderFor(expenseCategoryRepository)
final expenseCategoryRepositoryProvider = ExpenseCategoryRepositoryProvider._();

final class ExpenseCategoryRepositoryProvider
    extends
        $FunctionalProvider<
          ExpenseCategoryRepository,
          ExpenseCategoryRepository,
          ExpenseCategoryRepository
        >
    with $Provider<ExpenseCategoryRepository> {
  ExpenseCategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseCategoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseCategoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExpenseCategoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExpenseCategoryRepository create(Ref ref) {
    return expenseCategoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseCategoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseCategoryRepository>(value),
    );
  }
}

String _$expenseCategoryRepositoryHash() =>
    r'1b1e2bb9048b94b28ed4eea39483fb8712d6178d';

@ProviderFor(expenseCategories)
final expenseCategoriesProvider = ExpenseCategoriesProvider._();

final class ExpenseCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ExpenseCategory>>,
          List<ExpenseCategory>,
          FutureOr<List<ExpenseCategory>>
        >
    with
        $FutureModifier<List<ExpenseCategory>>,
        $FutureProvider<List<ExpenseCategory>> {
  ExpenseCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<ExpenseCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ExpenseCategory>> create(Ref ref) {
    return expenseCategories(ref);
  }
}

String _$expenseCategoriesHash() => r'686108691ef16ddc32bd4016a35c1650749d6b47';

@ProviderFor(expenseRemoteDataSource)
final expenseRemoteDataSourceProvider = ExpenseRemoteDataSourceProvider._();

final class ExpenseRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ExpenseRemoteDataSource,
          ExpenseRemoteDataSource,
          ExpenseRemoteDataSource
        >
    with $Provider<ExpenseRemoteDataSource> {
  ExpenseRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ExpenseRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExpenseRemoteDataSource create(Ref ref) {
    return expenseRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseRemoteDataSource>(value),
    );
  }
}

String _$expenseRemoteDataSourceHash() =>
    r'0ea454f2f044f8cf93e6faee773d27653089d073';

@ProviderFor(expenseRepository)
final expenseRepositoryProvider = ExpenseRepositoryProvider._();

final class ExpenseRepositoryProvider
    extends
        $FunctionalProvider<
          ExpenseRepository,
          ExpenseRepository,
          ExpenseRepository
        >
    with $Provider<ExpenseRepository> {
  ExpenseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExpenseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExpenseRepository create(Ref ref) {
    return expenseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseRepository>(value),
    );
  }
}

String _$expenseRepositoryHash() => r'586ff3925e69d5328e1f033f1439bc599e8837da';

@ProviderFor(expensesList)
final expensesListProvider = ExpensesListProvider._();

final class ExpensesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Expense>>,
          List<Expense>,
          FutureOr<List<Expense>>
        >
    with $FutureModifier<List<Expense>>, $FutureProvider<List<Expense>> {
  ExpensesListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expensesListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expensesListHash();

  @$internal
  @override
  $FutureProviderElement<List<Expense>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Expense>> create(Ref ref) {
    return expensesList(ref);
  }
}

String _$expensesListHash() => r'856a9be5b0fbcf055a13af9c5e5da22aeebbe5fc';
