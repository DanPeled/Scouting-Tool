T cast<T extends Object>(dynamic object) => object as T;
T? tryCast<T extends Object>(dynamic object, {T? defaultValue}) =>
    object is T ? object : defaultValue;
