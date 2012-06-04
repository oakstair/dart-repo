/*
 * Copyright 2012, the Dart project authors.
 * 
 * Licensed under the Eclipse Public License v1.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 * 
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */
package com.google.dart.engine.ast;

import com.google.dart.engine.scanner.Token;

/**
 * Instances of the class <code>FieldFormalParameter</code> represent a field formal parameter.
 * 
 * <pre>
 * fieldFormalParameter ::=
 *     ('final' {@link TypeName type} | 'const' {@link TypeName type} | 'var' | {@link TypeName type})? 'this' '.' {@link SimpleIdentifier identifier}
 * </pre>
 */
public class FieldFormalParameter extends NormalFormalParameter {
  /**
   * The token representing either the 'final', 'const' or 'var' keyword, or <code>null</code> if no
   * keyword was used.
   */
  private Token keyword;

  /**
   * The name of the declared type of the parameter, or <code>null</code> if the parameter does not
   * have a declared type.
   */
  private TypeName type;

  /**
   * The token representing the 'this' keyword.
   */
  private Token thisToken;

  /**
   * The token representing the period.
   */
  private Token period;

  /**
   * The name of the parameter being declared.
   */
  private SimpleIdentifier identifier;

  /**
   * Initialize a newly created formal parameter.
   */
  public FieldFormalParameter() {
  }

  /**
   * Initialize a newly created formal parameter.
   * 
   * @param keyword the token representing either the 'final', 'const' or 'var' keyword
   * @param type the name of the declared type of the parameter
   * @param thisToken the token representing the 'this' keyword
   * @param period the token representing the period
   * @param identifier the name of the parameter being declared
   */
  public FieldFormalParameter(Token keyword, TypeName type, Token thisToken, Token period,
      SimpleIdentifier identifier) {
    this.keyword = keyword;
    this.type = becomeParentOf(type);
    this.thisToken = thisToken;
    this.period = period;
    this.identifier = becomeParentOf(identifier);
  }

  @Override
  public <R> R accept(ASTVisitor<R> visitor) {
    return visitor.visitFieldFormalParameter(this);
  }

  @Override
  public Token getBeginToken() {
    if (keyword != null) {
      return keyword;
    } else if (type != null) {
      return type.getBeginToken();
    }
    return thisToken;
  }

  @Override
  public Token getEndToken() {
    return identifier.getEndToken();
  }

  /**
   * Return the name of the parameter being declared.
   * 
   * @return the name of the parameter being declared
   */
  public SimpleIdentifier getIdentifier() {
    return identifier;
  }

  /**
   * Return the token representing either the 'final', 'const' or 'var' keyword.
   * 
   * @return the token representing either the 'final', 'const' or 'var' keyword
   */
  public Token getKeyword() {
    return keyword;
  }

  /**
   * Return the token representing the period.
   * 
   * @return the token representing the period
   */
  public Token getPeriod() {
    return period;
  }

  /**
   * Return the token representing the 'this' keyword.
   * 
   * @return the token representing the 'this' keyword
   */
  public Token getThisToken() {
    return thisToken;
  }

  /**
   * Return the name of the declared type of the parameter, or <code>null</code> if the parameter
   * does not have a declared type.
   * 
   * @return the name of the declared type of the parameter
   */
  public TypeName getType() {
    return type;
  }

  /**
   * Set the name of the parameter being declared to the given identifier.
   * 
   * @param identifier the name of the parameter being declared
   */
  public void setIdentifier(SimpleIdentifier identifier) {
    this.identifier = becomeParentOf(identifier);
  }

  /**
   * Set the token representing either the 'final', 'const' or 'var' keyword to the given token.
   * 
   * @param keyword the token representing either the 'final', 'const' or 'var' keyword
   */
  public void setKeyword(Token keyword) {
    this.keyword = keyword;
  }

  /**
   * Set the token representing the period to the given token.
   * 
   * @param period the token representing the period
   */
  public void setPeriod(Token period) {
    this.period = period;
  }

  /**
   * Set the token representing the 'this' keyword to the given token.
   * 
   * @param thisToken the token representing the 'this' keyword
   */
  public void setThisToken(Token thisToken) {
    this.thisToken = thisToken;
  }

  /**
   * Set the name of the declared type of the parameter to the given type name.
   * 
   * @param typeName the name of the declared type of the parameter
   */
  public void setType(TypeName typeName) {
    type = becomeParentOf(typeName);
  }

  @Override
  public void visitChildren(ASTVisitor<?> visitor) {
    safelyVisitChild(type, visitor);
    safelyVisitChild(identifier, visitor);
  }
}
